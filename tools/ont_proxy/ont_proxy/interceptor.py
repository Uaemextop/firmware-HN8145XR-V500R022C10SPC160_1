import re
import logging
from mitmproxy import http
from ont_proxy.config import (
    ONT_HOST,
    ADMIN_USER_TYPE,
    FEATURE_FLAGS_OVERRIDE,
)

logger = logging.getLogger("ont_proxy.interceptor")

_RE_USER_TYPE = re.compile(
    r"""(var\s+curUserType\s*=\s*')([^']*)(')""",
    re.IGNORECASE,
)

_RE_HW_WEB_GET_USER_TYPE = re.compile(
    r"""(<%\s*HW_WEB_GetUserType\s*\(\s*\)\s*;?\s*%>)""",
)

_RE_IS_ADMIN_FUNC = re.compile(
    r"""function\s+IsAdminUser\s*\(\s*\)\s*\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}""",
    re.DOTALL,
)


def _build_feature_pattern():
    return re.compile(
        r"""(<%\s*HW_WEB_GetFeatureSupport\s*\(\s*)"""
        r"""([A-Za-z0-9_]+)"""
        r"""(\s*\)\s*;?\s*%>)""",
    )


_RE_FEATURE_SUPPORT = _build_feature_pattern()

_RE_MEGACABLE_FLAG = re.compile(
    r"""(var\s+isMegacableFlag\s*=\s*')([^']*)(')""",
    re.IGNORECASE,
)

_RE_NORMAL_USER_CHECK = re.compile(
    r"""curUserType\s*!=\s*['"]0['"]""",
)

_RE_NORMAL_USER_EQ_CHECK = re.compile(
    r"""curUserType\s*==\s*['"]0['"]""",
)


def _is_ont_traffic(flow: http.HTTPFlow) -> bool:
    host = flow.request.pretty_host
    return host == ONT_HOST or host.rstrip("/") == ONT_HOST


def _is_html_or_js(flow: http.HTTPFlow) -> bool:
    content_type = flow.response.headers.get("content-type", "")
    return any(
        t in content_type
        for t in ("text/html", "text/javascript", "application/javascript", "text/asp", "text/xml")
    )


def _patch_user_type(body: str) -> str:
    body = _RE_HW_WEB_GET_USER_TYPE.sub(ADMIN_USER_TYPE, body)
    body = _RE_USER_TYPE.sub(rf"\g<1>{ADMIN_USER_TYPE}\g<3>", body)
    return body


def _patch_feature_flags(body: str) -> str:
    def _replace_feature(match):
        prefix = match.group(1)
        flag_name = match.group(2)
        suffix = match.group(3)
        override = FEATURE_FLAGS_OVERRIDE.get(flag_name)
        if override is not None:
            return override
        return "1"

    return _RE_FEATURE_SUPPORT.sub(_replace_feature, body)


def _patch_admin_function(body: str) -> str:
    replacement = "function IsAdminUser() { return true; }"
    return _RE_IS_ADMIN_FUNC.sub(replacement, body)


def _patch_megacable_flag(body: str) -> str:
    return _RE_MEGACABLE_FLAG.sub(r"\g<1>1\g<3>", body)


def _patch_normal_user_checks(body: str) -> str:
    body = _RE_NORMAL_USER_CHECK.sub("false", body)
    body = _RE_NORMAL_USER_EQ_CHECK.sub("true", body)
    return body


def _remove_cache_headers(flow: http.HTTPFlow):
    flow.response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    flow.response.headers["Pragma"] = "no-cache"
    flow.response.headers["Expires"] = "0"


def _patch_menu_response(body: str) -> str:
    body = body.replace("<normal>", "<normal_disabled>")
    body = body.replace("</normal>", "</normal_disabled>")
    return body


class ONTInterceptor:
    def __init__(self, traffic_logger=None):
        self._logger = traffic_logger

    def response(self, flow: http.HTTPFlow):
        if not _is_ont_traffic(flow):
            return

        if self._logger:
            self._logger.log_flow(flow)

        if flow.response and flow.response.content:
            self._modify_response(flow)

    def _modify_response(self, flow: http.HTTPFlow):
        _remove_cache_headers(flow)

        if not _is_html_or_js(flow):
            return

        try:
            encoding = flow.response.headers.get("content-type", "")
            charset = "utf-8"
            if "charset=" in encoding:
                charset = encoding.split("charset=")[-1].strip().split(";")[0]

            body = flow.response.content.decode(charset, errors="replace")
        except Exception:
            body = flow.response.content.decode("utf-8", errors="replace")

        original = body
        body = _patch_user_type(body)
        body = _patch_feature_flags(body)
        body = _patch_admin_function(body)
        body = _patch_megacable_flag(body)
        body = _patch_normal_user_checks(body)

        url_path = flow.request.path.lower()
        if "getmenuarray" in url_path or "menu" in url_path:
            body = _patch_menu_response(body)

        if body != original:
            flow.response.content = body.encode(charset, errors="replace")
            flow.response.headers.pop("content-length", None)
            logger.info("Patched response: %s", flow.request.pretty_url)

import json
import time
import logging
from pathlib import Path
from mitmproxy import http

from ont_proxy.config import LOGS_DIR, ONT_HOST

logger = logging.getLogger("ont_proxy.traffic_logger")


class TrafficLogger:
    def __init__(self, log_dir: Path | None = None):
        self._log_dir = log_dir or LOGS_DIR
        self._log_dir.mkdir(parents=True, exist_ok=True)
        self._log_file = self._log_dir / "traffic.jsonl"
        self._fh = open(self._log_file, "a", encoding="utf-8")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
        return False

    def log_flow(self, flow: http.HTTPFlow):
        host = flow.request.pretty_host
        if host != ONT_HOST:
            return

        entry = {
            "timestamp": time.time(),
            "method": flow.request.method,
            "url": flow.request.pretty_url,
            "request_headers": dict(flow.request.headers),
            "response_status": flow.response.status_code if flow.response else None,
            "response_headers": dict(flow.response.headers) if flow.response else None,
            "content_type": (
                flow.response.headers.get("content-type", "") if flow.response else ""
            ),
        }

        try:
            if flow.request.content:
                entry["request_body"] = flow.request.content.decode("utf-8", errors="replace")
        except Exception:
            pass

        try:
            if flow.response and flow.response.content:
                ct = flow.response.headers.get("content-type", "")
                if any(t in ct for t in ("text/", "json", "xml", "javascript")):
                    entry["response_body"] = flow.response.content.decode(
                        "utf-8", errors="replace"
                    )
        except Exception:
            pass

        self._fh.write(json.dumps(entry, ensure_ascii=False) + "\n")
        self._fh.flush()

    def close(self):
        if self._fh:
            self._fh.close()

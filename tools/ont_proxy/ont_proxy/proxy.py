import logging
import sys
from pathlib import Path

from mitmproxy import options
from mitmproxy.tools.dump import DumpMaster

from ont_proxy.config import (
    PROXY_LISTEN_HOST,
    PROXY_LISTEN_PORT,
    CERTS_DIR,
    ONT_HOST,
)
from ont_proxy.interceptor import ONTInterceptor
from ont_proxy.traffic_logger import TrafficLogger
from ont_proxy.cert_manager import ensure_ca

logger = logging.getLogger("ont_proxy.proxy")


async def run_proxy(
    listen_host: str = PROXY_LISTEN_HOST,
    listen_port: int = PROXY_LISTEN_PORT,
    log_traffic: bool = True,
):
    cert_path, key_path = ensure_ca()
    logger.info("CA certificate: %s", cert_path)

    traffic_logger = TrafficLogger() if log_traffic else None
    interceptor = ONTInterceptor(traffic_logger=traffic_logger)

    opts = options.Options(
        listen_host=listen_host,
        listen_port=listen_port,
        ssl_insecure=True,
    )

    master = DumpMaster(opts)
    master.addons.add(interceptor)

    logger.info(
        "Proxy listening on %s:%d — intercepting %s",
        listen_host,
        listen_port,
        ONT_HOST,
    )

    try:
        await master.run()
    except KeyboardInterrupt:
        master.shutdown()
    finally:
        if traffic_logger:
            traffic_logger.close()

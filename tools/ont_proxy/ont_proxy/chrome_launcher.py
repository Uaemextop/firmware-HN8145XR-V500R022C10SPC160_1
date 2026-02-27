import json
import subprocess
import sys
import shutil
from pathlib import Path

from ont_proxy.config import (
    CHROME_PROFILE_DIR,
    PROXY_LISTEN_HOST,
    PROXY_LISTEN_PORT,
    ONT_HOST,
)


def _find_chrome() -> str | None:
    candidates = [
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        shutil.which("chrome") or "",
        shutil.which("google-chrome") or "",
    ]
    for path in candidates:
        if path and Path(path).exists():
            return path
    return None


def _write_preferences(profile_dir: Path):
    profile_dir.mkdir(parents=True, exist_ok=True)
    default_dir = profile_dir / "Default"
    default_dir.mkdir(parents=True, exist_ok=True)

    prefs = {
        "proxy": {
            "mode": "fixed_servers",
            "server": f"{PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}",
        },
        "net": {
            "proxy": {
                "type": "manual",
                "http": f"{PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}",
                "https": f"{PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}",
                "bypass_list": "",
            }
        },
        "browser": {
            "check_default_browser": False,
            "first_run_finished": True,
        },
    }
    prefs_path = default_dir / "Preferences"
    prefs_path.write_text(json.dumps(prefs, indent=2), encoding="utf-8")


def _build_pac_url() -> str:
    pac = (
        f"function FindProxyForURL(url, host) {{\n"
        f'  if (host === "{ONT_HOST}") {{\n'
        f'    return "PROXY {PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}";\n'
        f"  }}\n"
        f'  return "DIRECT";\n'
        f"}}\n"
    )
    pac_path = CHROME_PROFILE_DIR / "proxy.pac"
    CHROME_PROFILE_DIR.mkdir(parents=True, exist_ok=True)
    pac_path.write_text(pac, encoding="utf-8")
    return str(pac_path)


def launch_chrome(chrome_path: str | None = None) -> subprocess.Popen | None:
    chrome_path = chrome_path or _find_chrome()
    if not chrome_path:
        return None

    _write_preferences(CHROME_PROFILE_DIR)
    pac_file = _build_pac_url()

    args = [
        chrome_path,
        f"--user-data-dir={CHROME_PROFILE_DIR}",
        f"--proxy-pac-url=file://{pac_file}",
        "--ignore-certificate-errors",

        "--no-first-run",
        "--no-default-browser-check",
        f"http://{ONT_HOST}/",
    ]

    return subprocess.Popen(args)


def print_chrome_instructions():
    pac_file = _build_pac_url()
    chrome = _find_chrome()
    proxy_addr = f"{PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}"

    print("=" * 60)
    print("  Chrome Launch Instructions")
    print("=" * 60)
    if chrome:
        print(f"Chrome found: {chrome}")
    else:
        print("Chrome not found automatically. Use your Chrome path.")

    print(f"\nRun this command to launch Chrome with the proxy:\n")
    exe = chrome or "chrome.exe"
    print(
        f'  "{exe}" '
        f'--user-data-dir="{CHROME_PROFILE_DIR}" '
        f'--proxy-pac-url="file://{pac_file}" '
        f"--ignore-certificate-errors "
        f"--no-first-run "
        f"http://{ONT_HOST}/"
    )
    print(f"\nOr configure proxy manually: {proxy_addr}")
    print(f"PAC file: {pac_file}")
    print("=" * 60)

import argparse
import asyncio
import logging
import sys

from ont_proxy.config import (
    PROXY_LISTEN_HOST,
    PROXY_LISTEN_PORT,
    ONT_HOST,
)


def main():
    parser = argparse.ArgumentParser(description="ONT Proxy — Huawei HN8145XR traffic interceptor for Megacable")
    sub = parser.add_subparsers(dest="command")

    p_run = sub.add_parser("run", help="Start the MITM proxy server")
    p_run.add_argument("--host", default=PROXY_LISTEN_HOST)
    p_run.add_argument("--port", type=int, default=PROXY_LISTEN_PORT)
    p_run.add_argument("--no-log", action="store_true")

    p_cert = sub.add_parser("cert", help="Generate and install SSL certificate")
    p_cert.add_argument("--install", action="store_true", help="Install certificate in Windows root store")
    p_cert.add_argument("--script", action="store_true", help="Generate PowerShell install script only")

    p_chrome = sub.add_parser("chrome", help="Launch Chrome with proxy profile")
    p_chrome.add_argument("--path", default=None, help="Path to chrome.exe")

    p_info = sub.add_parser("info", help="Show proxy and configuration info")

    args = parser.parse_args()

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(name)s] %(levelname)s: %(message)s",
    )

    if args.command == "run":
        from ont_proxy.proxy import run_proxy

        asyncio.run(run_proxy(args.host, args.port, not args.no_log))

    elif args.command == "cert":
        from ont_proxy.cert_manager import ensure_ca, install_cert_windows, generate_install_script

        cert_path, key_path = ensure_ca()
        print(f"CA certificate: {cert_path}")
        print(f"CA private key: {key_path}")

        if args.install:
            ok = install_cert_windows(cert_path)
            if ok:
                print("Certificate installed successfully")
            else:
                print("Failed to install certificate (requires Administrator)")
                sys.exit(1)

        if args.script:
            script = generate_install_script(cert_path)
            print(f"PowerShell script: {script}")
            print("Run as Administrator: powershell -ExecutionPolicy Bypass -File " + str(script))

    elif args.command == "chrome":
        from ont_proxy.chrome_launcher import launch_chrome, print_chrome_instructions

        print_chrome_instructions()
        proc = launch_chrome(args.path)
        if proc:
            print(f"Chrome launched (PID: {proc.pid})")
        else:
            print("Chrome not found. Follow the instructions above.")

    elif args.command == "info":
        print(f"ONT Host:    {ONT_HOST}")
        print(f"Proxy:       {PROXY_LISTEN_HOST}:{PROXY_LISTEN_PORT}")
        print(f"ISP:         Megacable")
        print(f"Device:      Huawei HN8145XR V500R022C10SPC160")
        print(f"\nUsage:")
        print(f"  1. python run.py cert --script    # Generate certificate + installer")
        print(f"  2. python run.py cert --install    # Install certificate (Administrator)")
        print(f"  3. python run.py run               # Start proxy")
        print(f"  4. python run.py chrome             # Launch Chrome with proxy")

    else:
        parser.print_help()


if __name__ == "__main__":
    main()

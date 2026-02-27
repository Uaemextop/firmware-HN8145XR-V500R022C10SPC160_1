import datetime
import ipaddress
import subprocess
import sys
import os
from pathlib import Path

from cryptography import x509
from cryptography.x509.oid import NameOID
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import rsa

from ont_proxy.config import CERTS_DIR, ONT_HOST


def _build_san_entries(host: str) -> list:
    entries = [x509.DNSName(host)]
    try:
        entries.append(x509.IPAddress(ipaddress.IPv4Address(host)))
    except ValueError:
        pass
    return entries


def generate_ca(
    cert_path: Path | None = None,
    key_path: Path | None = None,
    cn: str = "ONT Proxy CA",
    days: int = 3650,
) -> tuple[Path, Path]:
    cert_path = cert_path or CERTS_DIR / "ont_proxy_ca.pem"
    key_path = key_path or CERTS_DIR / "ont_proxy_ca_key.pem"
    CERTS_DIR.mkdir(parents=True, exist_ok=True)

    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)

    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COMMON_NAME, cn),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "ONT Proxy"),
    ])

    now = datetime.datetime.now(datetime.timezone.utc)
    cert = (
        x509.CertificateBuilder()
        .subject_name(subject)
        .issuer_name(issuer)
        .public_key(key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now)
        .not_valid_after(now + datetime.timedelta(days=days))
        .add_extension(x509.BasicConstraints(ca=True, path_length=None), critical=True)
        .add_extension(
            x509.SubjectAlternativeName(_build_san_entries(ONT_HOST)),
            critical=False,
        )
        .sign(key, hashes.SHA256())
    )

    key_path.write_bytes(
        key.private_bytes(
            serialization.Encoding.PEM,
            serialization.PrivateFormat.TraditionalOpenSSL,
            serialization.NoEncryption(),
        )
    )
    cert_path.write_bytes(cert.public_bytes(serialization.Encoding.PEM))
    return cert_path, key_path


def install_cert_windows(cert_path: Path | None = None) -> bool:
    cert_path = cert_path or CERTS_DIR / "ont_proxy_ca.pem"
    if not cert_path.exists():
        return False

    script_path = generate_install_script(cert_path)
    try:
        subprocess.run(
            [
                "powershell", "-Command",
                "Start-Process", "powershell",
                "-Verb", "RunAs",
                "-ArgumentList",
                f"'-ExecutionPolicy Bypass -File \"{script_path}\"'",
            ],
            check=True,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def generate_install_script(cert_path: Path | None = None) -> Path:
    cert_path = cert_path or CERTS_DIR / "ont_proxy_ca.pem"
    script_path = CERTS_DIR / "install_cert.ps1"
    CERTS_DIR.mkdir(parents=True, exist_ok=True)

    content = (
        f'$cert = "{cert_path}"\n'
        'if (-Not (Test-Path $cert)) {\n'
        '    Write-Error "Certificate not found: $cert"\n'
        '    exit 1\n'
        '}\n'
        'Import-Certificate -FilePath $cert -CertStoreLocation Cert:\\LocalMachine\\Root\n'
        'Write-Host "Certificate installed in Local Machine Root store"\n'
    )
    script_path.write_text(content, encoding="utf-8")
    return script_path


def ensure_ca() -> tuple[Path, Path]:
    cert_path = CERTS_DIR / "ont_proxy_ca.pem"
    key_path = CERTS_DIR / "ont_proxy_ca_key.pem"
    if cert_path.exists() and key_path.exists():
        return cert_path, key_path
    return generate_ca(cert_path, key_path)

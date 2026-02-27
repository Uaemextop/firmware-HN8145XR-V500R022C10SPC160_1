param(
    [string]$CertPath = ".\certs\ont_proxy_ca.pem"
)

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -CertPath `"$CertPath`""
    exit
}

if (-Not (Test-Path $CertPath)) {
    Write-Error "Certificate file not found: $CertPath"
    Write-Host "Run 'python run.py cert' first to generate the certificate."
    exit 1
}

try {
    Import-Certificate -FilePath $CertPath -CertStoreLocation Cert:\LocalMachine\Root
    Write-Host "Certificate installed successfully in Local Machine Root store." -ForegroundColor Green
} catch {
    Write-Error "Failed to install certificate: $_"
    exit 1
}

Write-Host ""
Write-Host "You can now start the proxy: python run.py run" -ForegroundColor Cyan

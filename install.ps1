# Ensure running as Admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    exit 1
}

Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$chocoInstallPath = "C:\ProgramData\chocolatey"
$chocoBinPath = "$chocoInstallPath\bin"
$chocoExe = "$chocoBinPath\choco.exe"

# Step 1: Uninstall existing Chocolatey if present
if (Test-Path $chocoInstallPath) {
    Write-Host "Existing Chocolatey installation detected. Removing..."

    # Stop any chocolatey process (optional)
    Get-Process choco -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    # Remove Chocolatey folder (recursive)
    Remove-Item -Path $chocoInstallPath -Recurse -Force -ErrorAction Stop

    # Also remove chocolatey from PATH environment variables (system and user)
    function Remove-ChocoFromEnvPath($envPath) {
        $paths = $envPath -split ';' | Where-Object { $_ -and ($_ -notlike "*\chocolatey\bin") }
        return ($paths -join ';')
    }

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $newUserPath = Remove-ChocoFromEnvPath $userPath
    if ($newUserPath -ne $userPath) {
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
        Write-Host "Removed Chocolatey from User PATH."
    }

    $systemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $newSystemPath = Remove-ChocoFromEnvPath $systemPath
    if ($newSystemPath -ne $systemPath) {
        [Environment]::SetEnvironmentVariable("Path", $newSystemPath, "Machine")
        Write-Host "Removed Chocolatey from System PATH."
    }

    Write-Host "Chocolatey uninstalled."
} else {
    Write-Host "No existing Chocolatey installation found."
}

# Step 2: Install Chocolatey
Write-Host "Installing Chocolatey..."
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Step 3: Add Chocolatey to current session PATH
if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $chocoBinPath })) {
    $env:PATH += ";$chocoBinPath"
    Write-Host "Added Chocolatey to current session PATH."
}

# Step 4: Verify installation
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey installed successfully, version: $(choco --version)"
} else {
    Write-Error "Chocolatey installation failed or choco command not found."
    exit 1
}

# Step 5: Install Docker Desktop silently
Write-Host "Installing Docker Desktop via Chocolatey..."
choco install docker-desktop --yes --ignore-checksums --no-progress

Write-Host "All done!"

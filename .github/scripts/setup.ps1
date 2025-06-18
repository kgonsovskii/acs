# Setup script for GitVerse CI/CD pipeline

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "Please run this script as Administrator"
    exit 1
}

# Install required tools
Write-Host "Installing required tools..."

# Install .NET SDK 7.0
Write-Host "Installing .NET SDK 7.0..."
winget install Microsoft.DotNet.SDK.7

# Install Docker Desktop
Write-Host "Installing Docker Desktop..."
winget install Docker.DockerDesktop

# Install GitVerse CLI (if available)
Write-Host "Installing GitVerse CLI..."
# Add GitVerse CLI installation command when available

# Configure GitVerse
Write-Host "Configuring GitVerse..."
$configPath = ".gitverse/config.yml"
if (Test-Path $configPath) {
    Write-Host "GitVerse configuration found at $configPath"
} else {
    Write-Error "GitVerse configuration not found at $configPath"
    exit 1
}

# Verify Docker registry access
Write-Host "Verifying Docker registry access..."
$registry = "registry.astralinux.ru"
try {
    docker login $registry
    Write-Host "Successfully logged into Docker registry"
} catch {
    Write-Error "Failed to login to Docker registry: $_"
    exit 1
}

Write-Host "Setup completed successfully!"
Write-Host "Please make sure to:"
Write-Host "1. Configure GitVerse secrets in the repository settings"
Write-Host "2. Enable CI/CD in the repository settings"
Write-Host "3. Configure branch protection rules" 
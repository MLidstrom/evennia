#!/usr/bin/env pwsh
# Access the Evennia development container shell
# This script opens an interactive bash shell in the evennia_dev container

Write-Host "Connecting to Evennia development container..." -ForegroundColor Cyan
Write-Host "Type 'exit' to return to your host shell" -ForegroundColor Gray

# Check if container is running first
$containerStatus = docker ps -q -f name=evennia_dev

if (-not $containerStatus) {
    Write-Host "Error: evennia_dev container is not running!" -ForegroundColor Red
    Write-Host "Use 'dev-up.ps1' to start the development environment first" -ForegroundColor Yellow
    exit 1
}

docker exec -it evennia_dev bash

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to connect to container shell" -ForegroundColor Red
    exit $LASTEXITCODE
}

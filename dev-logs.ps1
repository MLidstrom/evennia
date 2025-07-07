#!/usr/bin/env pwsh
# Follow Docker Compose logs for development environment
# This script shows and follows logs from all containers

Write-Host "Following logs from development environment..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop following logs" -ForegroundColor Gray

# Check if any containers are running
$runningContainers = docker-compose ps -q

if (-not $runningContainers) {
    Write-Host "Error: No containers are running!" -ForegroundColor Red
    Write-Host "Use 'dev-up.ps1' to start the development environment first" -ForegroundColor Yellow
    exit 1
}

docker-compose logs -f

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to follow container logs" -ForegroundColor Red
    exit $LASTEXITCODE
}

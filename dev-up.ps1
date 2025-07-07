#!/usr/bin/env pwsh
# Start development environment with Docker Compose
# This script builds and starts all containers in detached mode

Write-Host "Starting development environment..." -ForegroundColor Green
docker-compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "Development environment started successfully!" -ForegroundColor Green
    Write-Host "Use 'dev-logs.ps1' to view container logs" -ForegroundColor Cyan
    Write-Host "Use 'dev-sh.ps1' to access the Evennia container shell" -ForegroundColor Cyan
} else {
    Write-Host "Failed to start development environment" -ForegroundColor Red
    exit $LASTEXITCODE
}

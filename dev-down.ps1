#!/usr/bin/env pwsh
# Stop development environment with Docker Compose
# This script stops and removes all containers

Write-Host "Stopping development environment..." -ForegroundColor Yellow
docker-compose down

if ($LASTEXITCODE -eq 0) {
    Write-Host "Development environment stopped successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to stop development environment" -ForegroundColor Red
    exit $LASTEXITCODE
}

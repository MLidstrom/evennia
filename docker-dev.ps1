#!/usr/bin/env pwsh
# Docker development helper script for Evennia

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

function Show-Help {
    Write-Host "Evennia Docker Development Helper" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: ./docker-dev.ps1 [command]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  help       - Show this help message"
    Write-Host "  build      - Build the Docker containers"
    Write-Host "  up         - Start the development environment"
    Write-Host "  down       - Stop the development environment"
    Write-Host "  shell      - Start a shell in the Evennia container"
    Write-Host "  logs       - Show container logs"
    Write-Host "  restart    - Restart the containers"
    Write-Host "  clean      - Clean up containers and volumes"
    Write-Host "  init       - Initialize a new Evennia game"
    Write-Host "  start      - Start the Evennia server (inside container)"
    Write-Host "  stop       - Stop the Evennia server (inside container)"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  ./docker-dev.ps1 build     # Build containers"
    Write-Host "  ./docker-dev.ps1 up        # Start development environment"
    Write-Host "  ./docker-dev.ps1 shell     # Get a shell to run evennia commands"
    Write-Host ""
}

function Build-Containers {
    Write-Host "Building Docker containers..." -ForegroundColor Green
    docker-compose build
}

function Start-Environment {
    Write-Host "Starting development environment..." -ForegroundColor Green
    docker-compose up -d
}

function Stop-Environment {
    Write-Host "Stopping development environment..." -ForegroundColor Green
    docker-compose down
}

function Start-Shell {
    Write-Host "Starting shell in Evennia container..." -ForegroundColor Green
    docker-compose exec evennia bash
}

function Show-Logs {
    Write-Host "Showing container logs..." -ForegroundColor Green
    docker-compose logs -f
}

function Restart-Containers {
    Write-Host "Restarting containers..." -ForegroundColor Green
    docker-compose restart
}

function Clean-Environment {
    Write-Host "Cleaning up containers and volumes..." -ForegroundColor Red
    $confirm = Read-Host "This will remove all containers and volumes. Continue? (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        docker-compose down -v
        docker system prune -f
    }
}

function Initialize-Game {
    Write-Host "Initializing new Evennia game..." -ForegroundColor Green
    if (-not (Test-Path "mygame")) {
        docker-compose run --rm evennia evennia --init mygame
    } else {
        Write-Host "Game directory 'mygame' already exists!" -ForegroundColor Yellow
    }
}

function Start-Server {
    Write-Host "Starting Evennia server..." -ForegroundColor Green
    docker-compose exec evennia evennia start
}

function Stop-Server {
    Write-Host "Stopping Evennia server..." -ForegroundColor Green
    docker-compose exec evennia evennia stop
}

switch ($Command.ToLower()) {
    "help" { Show-Help }
    "build" { Build-Containers }
    "up" { Start-Environment }
    "down" { Stop-Environment }
    "shell" { Start-Shell }
    "logs" { Show-Logs }
    "restart" { Restart-Containers }
    "clean" { Clean-Environment }
    "init" { Initialize-Game }
    "start" { Start-Server }
    "stop" { Stop-Server }
    default { 
        Write-Host "Unknown command: $Command" -ForegroundColor Red
        Show-Help 
    }
}

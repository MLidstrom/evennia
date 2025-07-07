# Docker Development Environment

This document provides comprehensive guidance for using Docker with Evennia development, particularly for Windows users working with WSL2.

## Prerequisites and One-Time Setup

### System Requirements

- **Windows 10/11** with WSL2 enabled
- **Docker Desktop** installed and running
- **Git** configured with `core.autocrlf = input` (already configured globally)
- **Python 3.11+** (if running without Docker)

### Docker Installation

1. **Install Docker Desktop**:
   - Download from [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
   - Enable WSL2 integration during installation
   - Ensure Docker Desktop is configured to use WSL2 backend

2. **Verify Docker Installation**:
   ```bash
   docker --version
   docker-compose --version
   ```

3. **Configure Docker Desktop**:
   - Open Docker Desktop settings
   - Go to "Resources" → "WSL Integration"
   - Enable integration with your default WSL distribution (Ubuntu)
   - Apply & Restart

### Initial Project Setup

1. **Clone the repository** (if not already done):
   ```bash
   git clone https://github.com/evennia/evennia.git
   cd evennia
   ```

2. **Build the Docker image**:
   ```bash
   docker-compose build
   ```

3. **Create initial game directory** (if needed):
   ```bash
   mkdir -p server mygame
   ```

## How to Start/Stop the Stack

### Starting the Development Environment

The project includes two Docker Compose configurations:

- **`docker-compose.yml`**: Base configuration for running Evennia
- **`docker-compose.override.yml`**: Development overrides (interactive shell)

#### Option 1: Interactive Development (Recommended)

```bash
# Start container with interactive shell
docker-compose up -d

# Connect to the running container
docker-compose exec evennia bash

# Inside the container, start Evennia
evennia migrate
evennia start --reload --log
```

#### Option 2: Direct Server Start

```bash
# Start Evennia server directly
docker-compose -f docker-compose.yml up
```

### Stopping the Stack

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

### Common Development Commands

```bash
# View logs
docker-compose logs -f evennia

# Restart just the evennia service
docker-compose restart evennia

# Rebuild and restart
docker-compose up --build -d

# Run one-off commands
docker-compose exec evennia evennia migrate
docker-compose exec evennia evennia shell
```

## Volume Mapping (Windows ↔ Container)

The Docker setup uses several volume mounts to enable live development:

### Main Volume Mappings

| Host Path (Windows) | Container Path | Purpose |
|---------------------|----------------|---------|
| `./server` | `/app` | Live code + game directory |
| `./mygame` | `/usr/src/game` | Game-specific files |
| `./evennia` | `/usr/src/evennia/evennia` | Evennia library source |
| `./docs` | `/usr/src/evennia/docs` | Documentation |
| `./bin` | `/usr/src/evennia/bin` | Executable scripts |

### How Volume Mapping Works

1. **Live Code Editing**: Changes made in your Windows IDE/editor are immediately reflected in the container
2. **Database Persistence**: Game data persists between container restarts
3. **Log Access**: Logs are accessible from both Windows and container

### File Permissions

Since you're using WSL2 with `core.autocrlf = input`, line endings are handled automatically. The volume mounts preserve file permissions between Windows and Linux.

## Troubleshooting

### Common Issues and Solutions

#### 1. Permission Errors

**Problem**: Permission denied errors when accessing files

**Solution**:
```bash
# Fix ownership inside container
docker-compose exec evennia chown -R evennia:evennia /app /usr/src/game

# Or restart Docker Desktop and try again
```

#### 2. Stale Volumes

**Problem**: Old data interfering with development

**Solution**:
```bash
# Remove all volumes and start fresh
docker-compose down -v
docker-compose up --build -d

# Or remove specific volumes
docker volume ls
docker volume rm evennia_volume_name
```

#### 3. Port Conflicts

**Problem**: Ports 4000, 4001, or 4002 already in use

**Solutions**:
```bash
# Check what's using the ports
netstat -ano | findstr :4000
netstat -ano | findstr :4001
netstat -ano | findstr :4002

# Kill processes using the ports (replace PID)
taskkill /F /PID <PID>

# Or modify docker-compose.yml to use different ports
ports:
  - "4010:4000"  # telnet
  - "4011:4001"  # web
  - "4012:4002"  # websocket
```

#### 4. Container Won't Start

**Problem**: Container exits immediately or fails to start

**Diagnostic Steps**:
```bash
# Check container logs
docker-compose logs evennia

# Check container status
docker-compose ps

# Try running container interactively
docker-compose run --rm evennia bash
```

**Common Fixes**:
- Ensure Docker Desktop is running
- Check for syntax errors in docker-compose files
- Verify all required files exist
- Rebuild the image: `docker-compose build --no-cache`

#### 5. Database Issues

**Problem**: Database connection errors or migration failures

**Solution**:
```bash
# Reset database
docker-compose down -v
docker-compose up -d
docker-compose exec evennia evennia migrate
```

#### 6. Hot Reload Not Working

**Problem**: Code changes not reflected in running server

**Potential Causes & Solutions**:
- Ensure you're using the development override: `docker-compose up` (not `-f docker-compose.yml`)
- Check volume mounts are correctly configured
- Restart the Evennia process inside the container:
  ```bash
  docker-compose exec evennia evennia reload
  ```

### WSL2 Specific Issues

#### Docker Desktop Integration

If Docker commands don't work in WSL2:
```bash
# Ensure Docker Desktop WSL2 integration is enabled
# Check Docker Desktop → Settings → Resources → WSL Integration
```

#### File System Performance

For better performance, ensure your project is located in the WSL2 file system:
```bash
# Good: /home/user/projects/evennia
# Avoid: /mnt/c/Users/user/projects/evennia
```

### Development Workflow Tips

1. **Use the interactive shell**: Start with `docker-compose up -d` then `docker-compose exec evennia bash`
2. **Keep containers running**: Use `docker-compose restart evennia` instead of full `down`/`up` cycles
3. **Monitor logs**: Keep `docker-compose logs -f evennia` running in a separate terminal
4. **Database backups**: Regularly backup your development database
5. **Clean builds**: Occasionally run `docker-compose build --no-cache` to ensure clean builds

### Getting Help

If you encounter issues not covered here:

1. Check the container logs: `docker-compose logs evennia`
2. Verify Docker Desktop is running and properly configured
3. Ensure all file paths are correct for your Windows/WSL2 setup
4. Try a clean rebuild: `docker-compose down -v && docker-compose build --no-cache`
5. Consult the [Evennia documentation](https://www.evennia.com/docs/latest) for Evennia-specific issues
6. Ask on the [Evennia Discord](https://discord.gg/AJJpcRUhtF) or [GitHub Discussions](https://github.com/evennia/evennia/discussions)

## Quick Reference

### Essential Commands

```bash
# Start development environment
docker-compose up -d

# Connect to container
docker-compose exec evennia bash

# View logs
docker-compose logs -f evennia

# Stop everything
docker-compose down

# Clean restart
docker-compose down -v && docker-compose up --build -d

# Run Evennia commands
docker-compose exec evennia evennia migrate
docker-compose exec evennia evennia start --reload --log
docker-compose exec evennia evennia reload
```

### Port Mappings

- **4000**: Telnet/MUD client connections
- **4001**: Web interface
- **4002**: WebSocket connections

### Important Paths

- **Game files**: `./server/` (Windows) → `/app/` (Container)
- **Evennia source**: `./evennia/` (Windows) → `/usr/src/evennia/evennia/` (Container)
- **Logs**: Available in both Windows and container file systems

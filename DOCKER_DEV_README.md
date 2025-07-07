# Evennia Docker Development Setup

This setup allows you to develop Evennia locally while running the server in Docker containers. This approach gives you the benefits of containerization while keeping your development workflow smooth.

## Prerequisites

- Docker Desktop for Windows with WSL 2 support
- Your Evennia source code (this directory)

## Quick Start

1. **Build the containers:**
   ```powershell
   .\docker-dev.ps1 build
   ```

2. **Start the development environment:**
   ```powershell
   .\docker-dev.ps1 up
   ```

3. **Initialize a new game (first time only):**
   ```powershell
   .\docker-dev.ps1 init
   ```

4. **Get a shell to run Evennia commands:**
   ```powershell
   .\docker-dev.ps1 shell
   ```

   Inside the container shell, you can run:
   ```bash
   evennia migrate
   evennia start
   ```

## How It Works

### Container Architecture

- **evennia**: Main Evennia application container
- **db**: PostgreSQL database container
- **redis**: Redis cache container

### Volume Mounts

Your local directories are mounted into the containers:
- `./mygame` → `/usr/src/game` (your game files)
- `./evennia` → `/usr/src/evennia/evennia` (Evennia source for development)
- `./docs` → `/usr/src/evennia/docs` (documentation)
- `./bin` → `/usr/src/evennia/bin` (scripts)

This means:
- ✅ You can edit files locally with your favorite editor
- ✅ Changes are immediately reflected in the container
- ✅ Database and cache persist between container restarts
- ✅ You can modify Evennia core code if needed

## Development Workflow

### Starting Development

```powershell
# Start all services
.\docker-dev.ps1 up

# Get a shell in the Evennia container
.\docker-dev.ps1 shell
```

### Inside the Container

```bash
# First time setup
evennia migrate
evennia collectstatic

# Start the server
evennia start

# Or start in interactive mode
evennia istart
```

### Editing Code

- Edit your game files in `./mygame/` using your local editor
- Edit Evennia core files in `./evennia/` if needed
- Changes are automatically reflected in the running container

### Accessing Your Game

- **Web interface**: http://localhost:4001
- **Telnet**: localhost:4000
- **WebSocket**: ws://localhost:4002

## Available Commands

Run `.\docker-dev.ps1 help` for a full list of commands:

- `build` - Build Docker containers
- `up` - Start the development environment
- `down` - Stop the development environment
- `shell` - Get a shell in the Evennia container
- `logs` - Show container logs
- `restart` - Restart containers
- `clean` - Clean up containers and volumes
- `init` - Initialize a new Evennia game
- `start` - Start Evennia server (inside container)
- `stop` - Stop Evennia server (inside container)

## Database Management

The PostgreSQL database runs in a container with these settings:
- **Host**: localhost (from your machine) or `db` (from containers)
- **Port**: 5432
- **Database**: evennia
- **Username**: evennia
- **Password**: evennia

You can connect to it using any PostgreSQL client.

## Troubleshooting

### Container Won't Start
```powershell
# Check logs
.\docker-dev.ps1 logs

# Rebuild containers
.\docker-dev.ps1 down
.\docker-dev.ps1 build
.\docker-dev.ps1 up
```

### Database Issues
```powershell
# Reset database (WARNING: This deletes all data!)
.\docker-dev.ps1 clean
.\docker-dev.ps1 up
.\docker-dev.ps1 init
```

### Permission Issues
Make sure Docker Desktop has access to your drive in Settings → Resources → File Sharing.

## Production Deployment

For production, you'll want to:
1. Use the main `docker-compose.yml` without the override
2. Set proper environment variables
3. Use external database services
4. Configure proper security settings

```powershell
# Start without development overrides
docker-compose -f docker-compose.yml up -d
```

## File Structure

```
.
├── docker-compose.yml          # Main Docker Compose configuration
├── docker-compose.override.yml # Development overrides
├── docker-dev.ps1             # Helper script
├── Dockerfile                 # Evennia container definition
├── mygame/                    # Your game files (created by init)
└── evennia/                   # Evennia source code
```

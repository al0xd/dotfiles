#!/bin/zsh

# ================================================================
# Personal Aliases & Functions
# ================================================================

# =============
# Docker Aliases
# =============
alias dcu='docker compose up --remove-orphans'
alias dc='docker compose'
alias dce='docker compose exec'
alias dcb='docker compose build'
alias dcd='docker compose down'
alias dcrs='docker compose restart'

# =============
# Cloudflare Aliases
# =============
alias clr='cloudflared tunnel --loglevel debug run'

# =============
# Fly.io Aliases
# =============
alias fssh='fly ssh console'
alias fsshc='fly ssh console --pty -C "bin/rails console"'
alias flog='fly logs'

# =============
# Docker Functions
# =============

# Execute bash in docker container
dceb() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dceb <service_name>"
    echo "   Example: dceb web"
    return 1
  fi
  echo "🐳 docker compose exec -it $1 bash"
  docker compose exec -it "$1" bash
}

# Show docker container logs with optional grep
dclog() {
  if [[ -z "$1" ]]; then
    echo "❌ Usage: dclog <service_name> [-grep <pattern>]"
    echo "   Example: dclog web"
    echo "   Example: dclog web -grep ERROR"
    return 1
  fi
  
  if [[ "$2" == "-grep" && -n "$3" ]]; then
    echo "🐳 docker compose logs -f $1 | grep $3"
    docker compose logs -f "$1" | grep "$3"
  else
    echo "🐳 docker compose logs -f $1"
    docker compose logs -f "$1"
  fi
}

# =============
# Help Command
# =============
alias-help() {
  echo ""
  echo "🚀 Personal Aliases & Functions Help"
  echo "═══════════════════════════════════════"
  echo ""
  echo "📦 DOCKER ALIASES:"
  echo "  dcu     → docker compose up --remove-orphans"
  echo "  dc      → docker compose"
  echo "  dce     → docker compose exec"
  echo "  dcb     → docker compose build"
  echo "  dcd     → docker compose down"
  echo "  dcrs    → docker compose restart"
  echo ""
  echo "📦 DOCKER FUNCTIONS:"
  echo "  dceb <service>              → Execute bash in container"
  echo "  dclog <service> [-grep <pattern>] → Show container logs (with optional grep)"
  echo ""
  echo "☁️  CLOUDFLARE ALIASES:"
  echo "  clr     → cloudflared tunnel --loglevel debug run"
  echo ""
  echo "✈️  FLY.IO ALIASES:"
  echo "  fssh    → fly ssh console"
  echo "  fsshc   → fly ssh console --pty -C \"bin/rails console\""
  echo "  flog    → fly logs"
  echo ""
  echo "💡 HELP:"
  echo "  alias-help → Show this help message"
  echo ""
  echo "Usage examples:"
  echo "  dcu                    # Start all services"
  echo "  dceb web               # Execute bash in 'web' container"
  echo "  dclog web -grep ERROR  # Show web logs and filter for ERROR"
  echo "  fssh                   # SSH into fly.io app"
  echo ""
}

# Alias for help
alias ah='alias-help' 
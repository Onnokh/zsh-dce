# upsearch function to find docker-compose.yml file in the custom folder
upsearch () {
  slashes=${PWD//[^\/]/}
  directory="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    test -e "$directory/$1" && echo "$directory/$1" && return
    directory="$directory/.."
  done
}

# If the docker-compose.yml file is found, execute the command in the container
dce() {
  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    echo "Usage: dce <container_name> [command]"
    echo "Examples:"
    echo "  dce node                    # Open shell in 'node' container"
    echo "  dce node bash              # Run bash in 'node' container"
    echo "  dce node npm install       # Run npm install in 'node' container"
    return 1
  fi

  COMPOSE_PATH=$(upsearch docker-compose.yml)
  if [ -n "$COMPOSE_PATH" ]; then
    COMPOSE_DIR=$(cd "$(dirname "$COMPOSE_PATH")" || exit; pwd)
    
    # If only one argument is provided, assume they want a shell
    if [ $# -eq 1 ]; then
      echo "Opening shell in container: $1"
      docker compose -f "$COMPOSE_PATH" exec "$1" /bin/bash
    else
      # Multiple arguments provided, execute the command
      docker compose -f "$COMPOSE_PATH" exec "$@"
    fi
  else
    echo "docker-compose.yml not found."
    return 1
  fi
}

# Helper function to get docker-compose.yml path
_dce_get_compose_path() {
  upsearch docker-compose.yml
}

# Helper function to get available containers from docker-compose.yml
_dce_get_containers() {
  local compose_path=$(_dce_get_compose_path)
  if [ -n "$compose_path" ]; then
    # Try to get services from docker compose config (works even if containers aren't running)
    docker compose -f "$compose_path" config --services 2>/dev/null
  fi
}

# Autocomplete function using Zsh's completion system
_dce() {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments \
    '*:container:->containers'

  case $state in
    containers)
      local compose_path=$(_dce_get_compose_path)
      if [ -n "$compose_path" ]; then
        local -a containers
        # Get containers/services from docker compose
        containers=("${(@f)$(_dce_get_containers)}")
        if [ ${#containers[@]} -gt 0 ]; then
          _describe 'containers' containers
        fi
      fi
      ;;
  esac
}

# Register the completion function
compdef _dce dce

# Path to the configuration file for storing the search folder within the plugin folder
DOCKER_COMPOSE_CONFIG_FILE="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/dce/.dce_config"

# Load the CUSTOM_FOLDER from the config file if it exists
if [ -f "$DOCKER_COMPOSE_CONFIG_FILE" ]; then
  source "$DOCKER_COMPOSE_CONFIG_FILE"
else
  # Default directory if no configuration is found
  CUSTOM_FOLDER=~/dev
fi

# upsearch function to find docker-compose.yml file in the custom folder
upsearch() {
  local directory="$CUSTOM_FOLDER"

  while [ "$directory" != "/" ]; do
    if [ -f "$directory/docker-compose.yml" ]; then
      # Check if we are at the custom folder directory (e.g., ~/dev)
      if [ "$(realpath "$directory")" = "$(realpath "$CUSTOM_FOLDER")" ]; then
        echo "$directory/docker-compose.yml"
        return
      fi
    fi
    directory="$(dirname "$directory")"
  done
}

# Function to execute docker-compose commands from the located docker-compose.yml
dce() {
  # If --folder flag is provided, set the CUSTOM_FOLDER
  if [[ "$1" == "--folder" && -n "$2" ]]; then
    CUSTOM_FOLDER="$2"
    echo "export CUSTOM_FOLDER=\"$CUSTOM_FOLDER\"" > "$DOCKER_COMPOSE_CONFIG_FILE"
    echo "CUSTOM_FOLDER set to: $CUSTOM_FOLDER"
    return 0
  fi

  COMPOSE_PATH=$(upsearch)

  if [ -n "$COMPOSE_PATH" ]; then
    COMPOSE_DIR=$(dirname "$COMPOSE_PATH")

    # Instead of ${PWD/$COMPOSE_DIR/}, we use this approach:
    WORKDIR=${PWD#$COMPOSE_DIR}

    docker compose -f "$COMPOSE_PATH" exec -w "${WORKDIR:-/}" "$@"
  else
    echo "docker-compose.yml not found in $CUSTOM_FOLDER."
    return 1
  fi
}
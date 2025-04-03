# zsh-dce plugin

The `zsh-dce` plugin is a Zsh utility that helps you quickly navigate to your docker containers without losing the current folder context.

## Installation

### 1. Clone the Repository

You can install the plugin manually by cloning the repository into your `~/.oh-my-zsh/custom/plugins/` directory.

```sh
git clone https://github.com/Onnokh/zsh-dce ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/dce
```

### 2. Enable the Plugin in `~/.zshrc`

After cloning the repository, you need to enable the plugin in your Zsh configuration.

```sh
nano ~/.zshrc
```

#### Oh-my-zsh manager
Find the `plugins` section and add `dce` to the list of plugins:

```
plugins=(<other plugins> dce)
```

#### Manual
Add the following to your .zshrc:
```
source ~/.oh-my-zsh/custom/plugins/dce/dce.plugin.zsh
```

### 3. Reload ZSH configuration

After saving the changes to `.zshrc`, reload your Zsh configuration by running:

```sh
source ~/.zshrc
```

## Usage

This will enable the `dce` plugin and any other plugins you added.

Usage

Once the plugin is installed, you can use it as follows:

1. Navigate to a project:

Use the `dce` command followed by the project name:

```sh
dce <container_name> <command>
```

## Customization

The plugin assumes that your docker-compose.yml is located under `~/dev`. If your config file is in a different directory, you can customize the the folder with the following command:

```sh
dce --folder ~/path/to/your/config
```
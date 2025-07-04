<p align="center">
  <img src="scaf-logo.png" width="250px">
</p>

Usage: scaf project_slug [OPTIONS] [TEMPLATE]

**scaf** is a template manager that simplifies bootstrapping and updating projects.

## Features:

- 📥 Installs any template from any GitHub repo
- 🔄 Updates existing projects installed from Copier templates

## Currently available templates:

- 🏗️ [Six Feet Up Full Stack Template](https://github.com/sixfeetup/scaf-fullstack-template.git)
- 🪶 [Six Feet Up AWS Lambda App Template](https://github.com/sixfeetup/scaf-aws-lambda-app-template.git)

## Installation

Installation is supported on Linux and macOS:

```
curl -sSL https://raw.githubusercontent.com/sixfeetup/scaf/main/install.sh | bash
```

The installation script will install kubectl, kind, Tilt and uv if it can't
be found on your system.

## Creating a new project using this repo

Run `scaf myproject`, answer all the questions, and you'll have your new project!

Refer to the documentation of the template you installed.

## Usage

```
Usage: scaf project_slug [OPTIONS] [TEMPLATE]

Scaf - Project scaffolding CLI tool

Arguments:
  project_slug           The name of your new project (alphanumeric, -, _)

Options:
  --help, -h             Show this help message and exit
  --uninstall            Uninstall Scaf CLI from the system
  --upgrade              Upgrade Scaf to the latest version

Template:
  TEMPLATE               (Optional) Template source. Must be one of the following:
                          - https://github.com/sixfeetup/scaf-fullstack-template.git
                          - https://github.com/sixfeetup/scaf-aws-lambda-app-template.git
                          - Or a local path (e.g. ./my-template)
                          If omitted, you will be prompted to choose.

Advanced Copier Options:
  --defaults             Use default answers to template questions
  --vcs-ref <branch>     Use a specific Git branch/tag/commit from the template repo

Examples:
  scaf my-app
      # Creates a project named "my-app" and prompts to choose a template interactively.

  scaf my-app https://github.com/sixfeetup/scaf-fullstack-template.git
      # Creates "my-app" using the Fullstack template directly from GitHub.

  scaf my-app --defaults --vcs-ref main https://github.com/sixfeetup/scaf-aws-lambda-app-template.git
      # Creates "my-app" using the AWS Lambda template with defaults and from the 'main' branch.

  scaf my-app --defaults --vcs-ref main \$REPO_URL
      # Example with full path to CLI, using defaults and specific VCS reference.
      # REPO_URL must be one of the allowed template URLs above.
```

## Development on Scaf

### Nix Flake

scaf provides a Nix Flake to install all the required packages for development.
The Nix Flake ensures all developers are using the same versions of all packages
to develop on Scaf in an isolated environment.

Follow the instructions to install
[Nix](https://nixos.org/download/#download-nix) for your OS.

1. Ensure you have a recent version of Nix installed:

Nix Flakes are available in recent versions of Nix. You can check your Nix
version using:

```sh
nix --version
```

If you need to install or update Nix, you can follow the instructions on the Nix
installation page.

2. Enable experimental features:

You need to enable the experimental features in your Nix configuration. To do
this, add the following lines to your ~/.config/nix/nix.conf file. If the file
doesn't exist, you can create it:

```ini
experimental-features = nix-command flakes
```

3. Using Nix Flakes:

Once you have enabled the experimental features, you can use Nix Flakes with the
nix command. For example:

```sh
nix flake show
```

This command will display information about the flake in the current directory
if you have a flake.nix file.

Finally, install [Direnv](https://direnv.net/) and run `direnv allow`. The
direnv configuration in `.envrc` will use the flake to install the required
packages.

### Testing

To test the copier portion of Scaf, run the `./test-scaf.sh` script.

If you are not using the Nix development environment, create a virtual environment and
install black, isort and copier before running `./test-scaf.sh`.

Running `./test-scaf.sh -h` shows the usage instructions:

```shell
Usage: ./test-scaf.sh -t <template_folder> [-o <output_folder>] [-d <test_data>] [-h]
  -t <template_folder> Required: Specify the source folder for the template
  -o <output_folder>   Optional: Specify the output folder (default is /tmp/scaf-test)
  -d <test_data>       Optional: Specify a preset answers data file
  -h                   Show this help message
```


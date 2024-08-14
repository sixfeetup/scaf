#!/bin/sh

BRANCH=${SCAF_SCRIPT_BRANCH:-main}
SCAF_SCRIPT_URL="https://raw.githubusercontent.com/sixfeetup/scaf/${BRANCH}/scaf"
TEMP_DOWNLOAD="./scaf"
PREFERRED_BIN_FOLDER=${PREFERRED_BIN_FOLDER:-"${HOME}/.local/bin"}
DESTINATION="${PREFERRED_BIN_FOLDER}/scaf"


ensure_bin_folder() {
  if [ ! -d "$PREFERRED_BIN_FOLDER" ]; then
      echo "Creating $PREFERRED_BIN_FOLDER..."
      mkdir -p $PREFERRED_BIN_FOLDER
  fi
  if [ ! -w "$PREFERRED_BIN_FOLDER" ]; then
      echo "You don't have write permission to $PREFERRED_BIN_FOLDER."
      echo "Please run the script as a user who has write permission to $PREFERRED_BIN_FOLDER"
      echo "Or set PREFERRED_BIN_FOLDER to a writable directory."
      exit 1
  fi
  # verify if PREFERRED_BIN_FOLDER is in PATH or exit with advice.
  if ! [ -n "$PATH" ] && [ -n "$HOME" ] && echo "$PATH" | grep -q ":$HOME/.local/bin:"; then
      echo "Your PATH is missing $PREFERRED_BIN_FOLDER."
      echo "Please add the following line to your shell profile file (e.g. ~/.bashrc, ~/.zshrc, etc.)"
      echo "export PATH=\$PATH:$PREFERRED_BIN_FOLDER"
      echo "Or you can set PREFERRED_BIN_FOLDER to a writable directory that is already in your PATH."
      exit 1
  fi
}

command_exists() {
    command -v "$1" > /dev/null 2>&1
}

check_top_level_dependencies() {
    # these are dependencies that we depend on the user to have installed
    dependencies="bash curl make python3 docker git rsync"
    missing=""

    for dep in $dependencies; do
        if ! command_exists $dep ; then
            missing="$missing $dep"
        fi
    done

    if [ -z "$missing" ]; then
        echo "All top-level dependencies are installed."
        return 0
    fi

    echo "The following dependencies are missing:"
    for dep in $missing; do
        echo "- $dep"
    done

    os=$(uname -s 2>/dev/null || echo "Unknown")
    if [ "$os" = "Linux" ] && [ -f /proc/version ] && grep -qi microsoft /proc/version; then
        os="WSL"
    elif [ "$os" = "Unknown" ] && [ "${OSTYPE#msys}" != "$OSTYPE" ]; then
        os="Windows"
    fi

    # TODO: I wonder if we should look for nix, brew, apt-get, yum, etc. and provide instructions
    #       for those rather then strictly by OS.
    for dep in $missing; do
        case $dep in
            "bash")
                echo "Please install bash for consistent shell execution."
                ;;
            "curl")
                echo "Please install curl:"
                echo "  - Ubuntu/Debian: sudo apt-get install curl"
                echo "  - CentOS/Fedora: sudo yum install curl"
                echo "  - macOS: brew install curl"
                echo "  - Windows: Download from https://curl.se/windows/"
                ;;
            "make")
                echo "Please install make:"
                echo "  - Ubuntu/Debian: sudo apt-get install make"
                echo "  - CentOS/Fedora: sudo yum install make"
                echo "  - macOS: xcode-select --install"
                echo "    or: brew install make"
                echo "  - Windows: Install MinGW or use WSL"
                ;;
            "python3")
                echo "Please install python3:"
                echo "  - Ubuntu/Debian: sudo apt-get install python3"
                echo "  - CentOS/Fedora: sudo yum install python3"
                echo "  - macOS: brew install python"
                echo "  - Windows: Download from https://www.python.org/downloads/windows/"
                ;;
            "rsync")
                echo "Please install rsync:"
                echo "  - Ubuntu/Debian: sudo apt-get install rsync"
                echo "  - CentOS/Fedora: sudo yum install rsync"
                echo "  - macOS: brew install rsync"
                echo "  - Windows: Can be obtained from https://www.itefix.net/cwrsync"
                echo "    or: Install WSL and usesudo apt-get install rsync"
                ;;
            "docker")
                case $os in
                    "Darwin")
                        echo "Please install Docker Desktop for macOS:"
                        echo "Download from https://www.docker.com/products/docker-desktop"
                        ;;
                    "Linux")
                        echo "Please install Docker:"
                        echo "Ubuntu: sudo apt-get update && sudo apt-get install docker.io"
                        echo "CentOS: sudo yum install -y docker && sudo systemctl start docker"
                        ;;
                    "Windows"|"WSL")
                        echo "Please install Docker Desktop for Windows:"
                        echo "Download from https://docs.docker.com/desktop/install/windows-install/"
                        ;;
                    *)
                        echo "Please install Docker. Visit https://docs.docker.com/engine/install/ for instructions."
                        ;;
                esac
                ;;
            *)
                echo "Please install $dep."
                ;;
        esac
        echo
    done
    exit 1
}

check_git_config() {
    git config --get user.name > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Git user.name is not set. Please run:"
        echo "  git config --global user.name \"Your Name\""
        exit 1
    fi

    git config --get user.email > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Git user.email is not set. Please run:"
        echo "  git config --global user.email \"your@email.com\""
        exit 1
    fi
}

detect_os_and_arch() {
    os=$(uname -s)
    arch=$(uname -m)

    case "$os" in
        Linux*)
            case "$arch" in
                x86_64) os_arch="linux-amd64" ;;
                aarch64) os_arch="linux-arm64" ;;
                *)      os_arch="linux-unknown" ;;
            esac
            ;;
        Darwin*)
            case "$arch" in
                x86_64) os_arch="darwin-amd64" ;;
                arm64)  os_arch="darwin-arm64" ;;
                *)      os_arch="darwin-unknown" ;;
            esac
            ;;
        *)
            os_arch="unknown"
            ;;
    esac
    echo $os_arch
}

move_to_bin_folder() {
    DEST=${2:-$PREFERRED_BIN_FOLDER}
    echo "Moving $1 to ${DEST}..."
    # if the DEST folder is not writable, use sudo to move the file
    if [ -w $DEST ]; then
        mv $1 $DEST/$1
    else
        sudo mv $1 $DEST/$1
    fi
}

install_kubectl() {
    echo "Installing kubectl..."
    os_arch=$(detect_os_and_arch)

    case $os_arch in
        "linux-amd64"|"darwin-amd64"|"darwin-arm64"|"linux-arm64")
            os=${os_arch%-*}
            arch=${os_arch#*-}
            url="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/${os}/${arch}/kubectl"
            curl -LO $url
            chmod +x ./kubectl
            move_to_bin_folder ./kubectl
            ;;
        *)
            echo "Unsupported OS or architecture: $os_arch"
            exit 1
            ;;
    esac
    kubectl version
}

install_kind() {
    echo "Installing kind..."
    os_arch=$(detect_os_and_arch)

    case $os_arch in
        "linux-amd64"|"darwin-amd64"|"darwin-arm64"|"linux-arm64"|"windows-amd64")
        curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.23.0/kind-$os_arch"
        chmod +x ./kind
        move_to_bin_folder ./kind
        ;;
    *)
        echo "Unsupported OS or architecture: $os_arch"
        exit 1
        ;;
    esac
    kind version
}

install_tilt() {
    echo "Installing tilt..."
    curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
    tilt version
}

install_scaf() {
    # Download and install scaf
    echo "Downloading scaf from $SCAF_SCRIPT_URL..."
    curl -L $SCAF_SCRIPT_URL -o $TEMP_DOWNLOAD

    if [ -f "$TEMP_DOWNLOAD" ]; then
        chmod +x $TEMP_DOWNLOAD
        echo "Moving scaf to $DESTINATION..."
        move_to_bin_folder $TEMP_DOWNLOAD `dirname $DESTINATION`
        if [ -f "$DESTINATION" ]; then
            echo "scaf installed successfully at $DESTINATION"
        else
            echo "Failed to move scaf to the destination."
            exit 1
        fi
    else
        echo "Failed to download scaf."
        exit 1
    fi
}

# Start the installation process
ensure_bin_folder
check_top_level_dependencies
check_git_config

for tool in kubectl kind tilt; do
    if ! command_exists $tool; then
        echo "$tool is not installed."
        install_$tool
    else
        echo "$tool is already installed."
    fi
done

if ! command_exists scaf; then
    install_scaf
else
    echo "scaf is already installed."
fi

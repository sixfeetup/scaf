#!/bin/bash

SCAF_SCRIPT_URL="https://github.com/sixfeetup/scaf/raw/master/scaf"
TEMP_DOWNLOAD="./scaf"
DESTINATION="/usr/local/bin/scaf"

command_exists() {
    type "$1" &> /dev/null
}

prompt_install() {
    read -p "Do you want to install $1? (y/n) " answer
    if [[ $answer = [Yy]* ]]; then
        install_$1
    else
        echo "Skipping installation of $1."
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

install_kubectl() {
    echo "Installing kubectl..."
    os_arch=$(detect_os_and_arch)

    case $os_arch in
        "linux-amd64"|"darwin-amd64"|"darwin-arm64"|"linux-arm64")
            url="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/$os_arch/kubectl"
            curl -LO $url
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl
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
        "linux-amd64"|"darwin-amd64"|"darwin-arm64"|"linux-arm64")
        curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-$os_arch"
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
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
    echo "Downloading scaf ..."
    curl -L $SCAF_SCRIPT_URL -o $TEMP_DOWNLOAD

    if [ -f "$TEMP_DOWNLOAD" ]; then
        chmod +x $TEMP_DOWNLOAD
        echo "Moving scaf to $DESTINATION..."
        sudo mv $TEMP_DOWNLOAD $DESTINATION
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

for tool in kubectl kind tilt; do
    if ! command_exists $tool; then
        echo "$tool is not installed."
        prompt_install $tool
    else
        echo "$tool is already installed."
    fi
done

if ! command_exists scaf; then
    install_scaf
else
    echo "scaf is already installed."
fi

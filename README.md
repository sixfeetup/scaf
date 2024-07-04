<p align="center">
  <img src="https://github.com/sixfeetup/cookiecutter-sixiedjango/assets/784273/4e378983-c351-4656-95b9-b5c38d70991d" width="450px">
</p>

**scaf** provides developers and DevOps engineers with a complete blueprint for
a new project and streamlines the development experience with Tilt.

**scaf** generates a new project structure with Kubernetes manifests in
three Kustomize layers for dev, sandbox, and production. A new project 
contains the following:
* NextJS or React frontend
* Django backend
* Postgres database for local development
* CloudNativePG deployment for production
* Redis
* Mailhog
* ArgoCD 
* Traefik
* Certmanger
* Certificates and Ingress Routes
* Kube Prometheus Stack
* Grafana Loki
* GitHub and Bitbucket pipelines to build and push images, run security,
formatting and linting checks
* Terraform config to set up a k3s cluster on AWS

## Installation

Installation is supported on Linux and macOS:
```
curl -sSL https://raw.githubusercontent.com/sixfeetup/scaf/main/install.sh | sh
```

The installation script will install kubectl, kind, and Tilt if it can't
be found on your system.

## Creating a new project using this repo

Run `scaf myproject`, answer all the questions, and you'll have your new project!

Inside `myproject/README.md`, you will have more
documentation explaining how to use and configure your newly created project.

## Architecture

Here is what a cookiecutter deployment looks like in practice:

```mermaid
flowchart LR
    PR["PR Merge"] --> CIDCD["CI/CD Pipeline"]
    CIDCD -->|Build & Push Images| AWSECR["AWS ECR Repo"]
    CIDCD -->|Update Image Tags| Kustomize
    CIDCD -->|Build & Push Static Content| S3
    Kustomize --> ArgoCD
    Cloudfront
    S3
    subgraph ControlPlaneCluster["Control Plane Cluster"]
        Loki["Grafana Loki"]
        Prometheus
        ArgoCD
    end
    subgraph K8sCluster["Kubernetes Cluster"]
        Django
        NextJS
        CloudNativePG
        Redis
        Celery
        Mailhog
    end
    ArgoCD -->|Deploy| K8sCluster
    Sentry
    Django -->|Sends Error Logs| Sentry
    NextJS -->|Sends Error Logs| Sentry
    K8sCluster -->|Sends Logs| Loki
    K8sCluster -->|Sends Metrics| Prometheus
    Cloudfront -->|Requests for API and Frontend Views| K8sCluster
    Cloudfront -->|Requests for Static Content and Media| S3

    style K8sCluster fill:#FFC107, stroke:#FFFFFF, stroke-width:1px
    style ControlPlaneCluster fill:#ff6361, stroke:#FFFFFF, stroke-width:1px

```

## Terraform and AWS

To deploy your project using Terraform and AWS, you can follow the instructions in `terraform/README.md.`  
Note that you will need:
- an AWS account where you have access to the `OrganizationAccountAccessRole`
- terraform, and AWS CLI installed and configured 

## Development on Scaf

### Nix Flake

Scaf provides a Nix Flake to install all the required packages for development.
The Nix Flake ensures all developers are using the same versions of all packages
to develop on Scaf in an isolated environment.

Follow the instructions to install
[Nix](https://nixos.org/download/#download-nix) for your OS. 

Nix Flakes are a feature that comes with Nix, but they are considered
experimental and are not enabled by default in stable releases of Nix. To use
Nix Flakes, you need to enable them by configuring your Nix installation to
allow experimental features.

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

### Django version updates

When making changes to scaf, keep the following in mind:

- update pins in requirements/*.in files but *don't\* commit the compiled requirements.txt
  files to the repo.
- update to the latest Python supported by Django. For Django 4.1, this is 3.8, 3.9, and 3.10.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51"
    }
    # TODO: add cookiecutter.use_talos check 
    talos = {
      source  = "siderolabs/talos"
      version = "0.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}

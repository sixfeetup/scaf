{
  description = "Scaf dev environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.copier
            pkgs.nodejs
            pkgs.nix-prefetch-git
            pkgs.python3
            pkgs.python3.pkgs.black
            pkgs.python3.pkgs.diagrams
            pkgs.python3.pkgs.isort
            pkgs.python3.pkgs.pip-tools
            pkgs.python3.pkgs.uv
            pkgs.shellcheck
          ];
          shellHook = ''
            echo "Scaf dev environment shell hook"
          '';
        };
      }
    );
}

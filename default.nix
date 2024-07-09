{ pkgs ? import <nixpkgs> {} }:

let
  lib = pkgs.lib;
  stdenv = pkgs.stdenv;
  makeWrapper = pkgs.makeWrapper;

  packageJson = builtins.fromJSON (builtins.readFile ./package.json);
  scafVersion = packageJson.version;
  maintainers = {
    sixfeetup = {
      name = "Six Feet Up";
      email = "info@sixfeetup.com";
    };
  };
in

stdenv.mkDerivation rec {
  pname = "scaf";
  version = scafVersion;

  src = pkgs.fetchFromGitHub {
    owner = "sixfeetup";
    repo = "scaf";
    rev = "v${version}";
    sha256 = "1qgd8wy25vfnwi6hg1dkaary1897qgfwhz8jgbjspsidh7bzlmd1";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pkgs.python3
    pkgs.python3.pkgs.cookiecutter
  ];

  propagatedBuildInputs = [
    pkgs.argocd
    pkgs.envsubst
    pkgs.jq
    pkgs.kind
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.podman
    pkgs.podman-compose
    pkgs.python3
    pkgs.python3.pkgs.black
    pkgs.python3.pkgs.cookiecutter
    pkgs.python3.pkgs.isort
    pkgs.python3.pkgs.pip-tools
    pkgs.tilt
  ];

  buildPhase = ''
    echo "No build necessary"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ${src}/scaf $out/bin/scaf

    makeWrapper $out/bin/scaf $out/bin/scaf \
      --set PATH ${lib.makeBinPath [
        pkgs.python3
        pkgs.python3.pkgs.cookiecutter
      ]}
  '';

  meta = with pkgs.lib; {
    description = "Scaf provides developers and DevOps engineers with a complete blueprint for a new project using Kubernetes";
    homepage = "https://github.com/sixfeetup/scaf";
    license = licenses.mit;
    maintainers = [ maintainers.sixfeetup ];
  };
}

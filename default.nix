{ pkgs ? import <nixpkgs> {} }:

let
  inherit(pkgs) lib stdenv makeWrapper;

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

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pkgs.python3
    pkgs.python3.pkgs.cookiecutter
  ];

  propagatedBuildInputs = [
    pkgs.awscli2
    pkgs.argocd
    pkgs.envsubst
    pkgs.go-task
    pkgs.jq
    pkgs.kind
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubeseal
    pkgs.opentofu
    pkgs.podman
    pkgs.podman-compose
    pkgs.python3
    pkgs.python3.pkgs.black
    pkgs.python3.pkgs.cookiecutter
    pkgs.python3.pkgs.isort
    pkgs.python3.pkgs.pip-tools
    pkgs.tilt
    pkgs.uv
  ];

  buildPhase = ''
    echo "No build necessary"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ./scaf $out/bin/scaf.sh

    makeWrapper $out/bin/scaf.sh $out/bin/scaf \
      --set PATH ${lib.makeBinPath [
        pkgs.python3
        pkgs.python3.pkgs.copier
      ]}
  '';

  meta = with pkgs.lib; {
    description = "Scaf provides developers and DevOps engineers with a complete blueprint for a new project using Kubernetes";
    homepage = "https://github.com/sixfeetup/scaf";
    license = licenses.mit;
    maintainers = [ maintainers.sixfeetup ];
  };
}

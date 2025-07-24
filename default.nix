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

  runtimeDeps = with pkgs; [
    awscli2
    argocd
    envsubst
    go-task
    jq
    kind
    kubectl
    kubernetes-helm
    kubeseal
    opentofu
    podman
    podman-compose
    python3
    python3.pkgs.black
    python3.pkgs.copier
    python3.pkgs.isort
    python3.pkgs.pip-tools
    tilt
    uv
  ];
in

stdenv.mkDerivation rec {
  pname = "scaf";
  version = scafVersion;

  src = ./.;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pkgs.python3
  ];

  propagatedBuildInputs = runtimeDeps;

  buildPhase = ''
    echo "No build necessary"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ./scaf $out/bin/scaf

    makeWrapper $out/bin/scaf $out/bin/scaf-wrapped \
      --set PATH ${lib.makeBinPath runtimeDeps}
    
    mv $out/bin/scaf-wrapped $out/bin/scaf
  '';

  meta = with pkgs.lib; {
    description = "Scaf provides developers and DevOps engineers with a complete blueprint for a new project using Kubernetes";
    homepage = "https://github.com/sixfeetup/scaf";
    license = licenses.mit;
    maintainers = [ maintainers.sixfeetup ];
  };
}

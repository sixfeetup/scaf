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
    coreutils
    copier
    envsubst
    git
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
    python3.pkgs.isort
    python3.pkgs.pip-tools
    talosctl
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
    # Install the original script with an internal name
    install -m 755 ./scaf $out/bin/.scaf-unwrapped

    # Wrap the internal script to create the final executable
    makeWrapper $out/bin/.scaf-unwrapped $out/bin/scaf \
      --set PATH ${lib.makeBinPath runtimeDeps}
  '';

  meta = with pkgs.lib; {
    description = "scaf is a template manager that simplifies bootstrapping and updating projects";
    homepage = "https://github.com/sixfeetup/scaf";
    license = licenses.mit;
    maintainers = [ maintainers.sixfeetup ];
  };
}

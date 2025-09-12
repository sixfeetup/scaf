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
    black
    coreutils
    copier
    docker
    envsubst
    git
    go-task
    gnumake
    isort
    jq
    kind
    kubectl
    kubernetes-helm
    kubeseal
    nodejs
    opentofu
    python3
    ruff
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

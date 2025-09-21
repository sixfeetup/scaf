{ pkgs ? import <nixpkgs> {} }:

let
  inherit(pkgs) stdenv writeShellApplication;

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

  src = ./.;

  buildPhase = ''
    echo "No build necessary"
  '';

  doCheck = true;
  checkInputs = with pkgs; [ shellcheck ];
  checkPhase = ''
    shellcheck ./scaf
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${scaf}/bin/scaf $out/bin/scaf
  '';

  scaf = writeShellApplication {
    name = pname;

    text = ./scaf;

    runtimeInputs = with pkgs; [
      awscli2
      argocd
      bashInteractive
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
  };

  meta = with pkgs.lib; {
    description = "scaf is a template manager that simplifies bootstrapping and updating projects";
    homepage = "https://github.com/sixfeetup/scaf";
    license = licenses.mit;
    maintainers = [ maintainers.sixfeetup ];
  };
}

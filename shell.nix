{
  pkgs ? import <nixpkgs> { },
}:

let
  pythonWithPackages = pkgs.python3.withPackages (
    ps: with ps; [
      pyyaml
      pillow
      ply
    ]
  );
  # use git nml
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # basic
    just
    gcc
    git

    # python with dependencies
    pythonWithPackages

    # other tools
    coreutils
    gnugrep

    # graphics generation
    aseprite
  ];
  shellHook = ''
    echo "WINS is ready!"
    just --list
  '';
}

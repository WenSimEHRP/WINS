with import <nixpkgs> { };
let
  revision = "fe701053066ec5f734026fcc6326187792098c14";
  openttd-nml = pkgs.openttd-nml.overrideAttrs (old: {
    version = "master-" + revision;
    src = pkgs.fetchFromGitHub {
      owner = "OpenTTD";
      repo = "nml";
      rev = revision;
      sha256 = "sha256-8ixbCR6mebu+yu/sYCI0im+mf41WSg9Xq8QtR8avBe8=";
    };
  });
in
mkShell {
  nativeBuildInputs = [
    coreutils
    gcc
    openttd-nml
    aseprite
    just
    python313
    python313Packages.pyyaml
  ];
}

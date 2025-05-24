with import <nixpkgs> { };
let
  revision = "2fe6c241e2d0885a924c2372af27b756998d76e8";
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
  ];
}

{}:
let
  nixpkgs = import <nixpkgs> {};
  inherit (nixpkgs) pkgs;
in pkgs.stdenv.mkDerivation {
  name = "treehouse-env";
  buildInputs = with pkgs; [
    keychain
    jq
    ranger
  ];
}

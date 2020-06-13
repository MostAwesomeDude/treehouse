{}:
let
  nixball = builtins.fetchTarball {
    name = "treehouse-pinned-nixpkgs";
    url = https://github.com/NixOS/nixpkgs/archive/79b919e75b4e24a31a86843d2a492733033485e5.tar.gz;
    sha256 = "0nrsifav05x5afkiaag0i11cisk8illmqasnbys14y1yws31q1aa";
  };
  nixpkgs = import nixball { };
  inherit (nixpkgs) pkgs;
  prometheus-mdns-sd = pkgs.callPackage ./prometheus-mdns-sd { };
in pkgs.stdenv.mkDerivation {
  name = "treehouse-env";
  buildInputs = with pkgs; [
    keychain
    prometheus-mdns-sd
  ];
}

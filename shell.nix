let
  sources = import ./nix/sources.nix;
in
{
    pkgs ? import sources.nixpkgs { }
}:

pkgs.stdenv.mkDerivation {
    name = "npm-shell";
    buildInputs = with pkgs; [
        nodejs-14_x
    ];      
}

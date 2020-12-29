with import <nixpkgs> {};
with pkgs;
mkShell {
    buildInputs = [
        inotify-tools
        nodejs-14_x
    ];
}
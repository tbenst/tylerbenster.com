let
  sources = import ./nix/sources.nix;
in
{ compiler ? "ghc884"
, pkgs ? import sources.nixpkgs { }
}:

let
  inherit (pkgs.lib.trivial) flip pipe;
  inherit (pkgs.haskell.lib) appendPatch appendConfigureFlags;

  haskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hpNew: hpOld: {
      hakyll =
        pipe
           hpOld.hakyll
           [ (flip appendPatch ./hakyll.patch)
             (flip appendConfigureFlags [ "-f" "watchServer" "-f" "previewServer" ])
           ];

      # fix locale issue
      # https://www.slamecka.cz/posts/2020-06-08-encoding-issues-with-nix-hakyll/
      tylerbenster-com = (hpNew.callCabal2nix "tylerbenster-com" ./. { }).overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs or [] ++ [
          pkgs.makeWrapper
        ];
        postInstall = old.postInstall or "" + ''
          wrapProgram $out/bin/site \
            --set LANG "en_US.UTF-8" \
            --set LOCALE_ARCHIVE "${pkgs.glibcLocales}/lib/locale/locale-archive"
        '';
      });

      niv = import sources.niv { };
    };
  };

  project = haskellPackages.tylerbenster-com;
in
{
  project = project;

  shell = haskellPackages.shellFor {
    packages = p: with p; [
      project
    ];
    buildInputs = with haskellPackages; with pkgs; [
      ghcid
      hlint       # or ormolu
      niv
      inotify-tools
      nodejs-14_x
      cacert # needed for niv
      nix    # needed for niv
    ];
    withHoogle = true;
  };
}

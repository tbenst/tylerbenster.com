{ # Fetch the latest haskell.nix and import its default.nix
  haskellNix ? import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz") {}

# haskell.nix provides access to the nixpkgs pins which are used by our CI,
# hence you will be more likely to get cache hits when using these.
# But you can also just use your own, e.g. '<nixpkgs>'.
, nixpkgsSrc ? haskellNix.sources.nixpkgs-2211

# haskell.nix provides some arguments to be passed to nixpkgs, including some
# patches and also the haskell.nix functionality itself as an overlay.
, nixpkgsArgs ? haskellNix.nixpkgsArgs

# import nixpkgs with overlays
, pkgs ? import nixpkgsSrc nixpkgsArgs
}: pkgs.haskell-nix.project {
  # 'cleanGit' cleans a source directory based on the files known by git
  src = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "tylerbenstercom";
    src = ./.;
  };

  modules = [{
      packages.tylerbenster-com.components.exes.site = {
        postInstall = ''
          wrapProgram $out/bin/site \
            --set LANG "en_US.UTF-8" \
            --set LOCALE_ARCHIVE "${pkgs.glibcLocales}/lib/locale/locale-archive"
        '';
        build-tools = [
          pkgs.makeWrapper
        ];
      };
  }];
  # Specify the GHC version to use.
  compiler-nix-name = "ghc944"; # Not required for `stack.yaml` based projects.
}

# tylerbenster.com

Edit the master branch only; CircleCI will build and push to Site, which is then hosted.

# Post-run
Once, by hand, must run `sudo certbot --nginx -d www.tylerbenster.com`

## Local haskell
```
nix-build && result/bin/site clean && result/bin/site watch
nix-shell shell.nix --run "npx postcss --watch static/css/entry.css -o static/master.css -v"
```

### nix / local cabal
`cabal install filepath --dry-run` then add to *.cabal file. Nix will install/build

```
## niv / nix
https://dev.to/rpearce/hakyll-pt-6-pure-builds-with-nix-4hb6
```
niv init
niv update nixpkgs -o NixOS -r nixpkgs -b nixos-20.09
```

### Initial setup:
See `add npm pkgs` in github actions workflow


## References
https://johanatan.github.io/posts/2017-04-13-hakyll-circleci.html

https://github.com/DevProgress/onboarding/wiki/Using-Circle-CI-with-Github-Pages-for-Continuous-Delivery
https://github.com/eldarlabs/ghpages-deploy-script

https://circleci.com/docs/1.0/config-sample/

## bibliography
use https://www.doi2bib.org/ and paste reference into papers/research.bib
```
```

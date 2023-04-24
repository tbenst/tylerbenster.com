# tylerbenster.com

Edit the master branch only; GitHub Actions will build and push to Site, which is then hosted.

# Post-run
Once, by hand, must run `sudo certbot --nginx -d www.tylerbenster.com`

## Building
```
nix-build -A tylerbenster-com.components.exes.site && result/bin/site clean && result/bin/site watch
nix-shell shell.nix --run "npx postcss --watch static/css/entry.css -o static/master.css -v"
```

### nix / local cabal
```
nix-shell --run 'cabal install <pkgToAdd> --dry-run'
# for libraries
nix-shell --run 'cabal install hakyll-images --dry-run --lib'
```

then add to *.cabal file. Nix will install/build

```
## niv / nix
https://dev.to/rpearce/hakyll-pt-6-pure-builds-with-nix-4hb6
```
niv init
niv update nixpkgs -o NixOS -r nixpkgs -b nixos-20.09
```
If haskell packages are marked as broken, can specify revision:
```
niv update nixpkgs -a rev=939e04ca726d99dfee838de841b16f3e91e5bc29
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

## compress images

[jpeg](https://dev.to/feldroy/til-strategies-for-compressing-jpg-files-with-imagemagick-5fn9):
```
convert feldroy-512x512-unoptimized.jpg \
-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace RGB -resize 1024 -auto-orient
feldroy-512x512-pagespeed.jpg
```

[png]
```
optipng -o3 vaccine_infographic_2.png
```

### future TODO (potentially)
if the build breaks again in future, perhaps should adopt nix flakes to pin dependencies
https://github.com/rpearce/hakyll-nix-template
# tylerbenster.com
[![CircleCI](https://circleci.com/gh/tbenst/tylerbenster.com.svg?style=svg&circle-token=644c3e1960b39a2a19cd795f1690f733a63a52a7)](https://circleci.com/gh/tbenst/tylerbenster.com)

Edit the master branch only; CircleCI will build and push to Site, which is then hosted.

# pre-run
should update keys, e.g. Sauron

# Post-run
Once, by hand, must run `sudo certbot --nginx -d www.tylerbenster.com`

## Local haskell
```
nix-build  && result/bin/site clean && result/bin/site watch
```

### nix / local cabal
`cabal install filepath --dry-run` then add to *.cabal file. Nix will install/build
### stack (deprecated)
```
stack setup # if no ghc installed on system
stack build && stack exec site clean && stack exec site watch
```

## Tailwind CSS
nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/a15d90fad2ecef46938e3b0e141ec66503026834

## niv / nix
https://dev.to/rpearce/hakyll-pt-6-pure-builds-with-nix-4hb6
```
niv init
niv update nixpkgs -o NixOS -r nixpkgs -b nixos-20.09
```

### Initial setup:
```
> npm install tailwindcss
> npm install @tailwindcss/typography
> npm i -D postcss postcss-cli postcss-import autoprefixer
```

### auto rebuild:
```
# using tailwind-cli
> while inotifywait -e close_write tailwind.config.js; do npx tailwindcss-cli@latest build -o static/css/tailwind.css; done
# using postcss-cli
> nix-shell
$ npx postcss --watch static/css/entry.css -o static/master.css -v
```

## References
https://johanatan.github.io/posts/2017-04-13-hakyll-circleci.html

https://github.com/DevProgress/onboarding/wiki/Using-Circle-CI-with-Github-Pages-for-Continuous-Delivery
https://github.com/eldarlabs/ghpages-deploy-script

https://circleci.com/docs/1.0/config-sample/

## bibliography
use https://www.doi2bib.org/ and paste reference into papers/papers.bib
```
pandoc chem.bib -s -f biblatex -t markdown
```

## Dockerfile backups
https://hub.docker.com/r/futtetennista/hakyll
4.12.5.1:

```
FROM haskell:8.6.3

ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

RUN apt-get update && apt-get install --yes \
  git \
  ssh

COPY stack.yaml /root/.stack/global-project/stack.yaml

RUN stack upgrade && \
  stack --resolver lts-13.6 install \
    base \
    bytestring \
    conduit-combinators \
    containers \
    hakyll \
    mtl \
    stm

EXPOSE 8000

ENTRYPOINT ["bash"]
```

4.12.5.1-ext
```
FROM futtetennista/hakyll:latest

RUN apt-get update && apt-get install --yes \
  curl \
  imagemagick \
  make

# https://github.com/commercialhaskell/stackage/issues/3132
RUN curl -sSL https://get.haskellstack.org/ | sh -s - -f

COPY stack.yaml.ext /root/.stack/global-project/stack.yaml

RUN stack --resolver lts-13.6 install \
  hakyll-favicon \
hakyll-sass
```

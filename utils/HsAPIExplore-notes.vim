
there is `stack haddock --open lens` to open the local docs of the lib
https://lexi-lambda.github.io/blog/2018/02/10/an-opinionated-guide-to-haskell-in-2018/
stack test --fast --haddock-deps --file-watch
stack hoogle -- generate --local
stack hoogle -- server --local --port=8080
This actually works and shows my local docs alongside the docs of dependencies:
http://localhost:8080/?hoogle=maptomaybe
shows function from TypeClasses/Functortown.hs




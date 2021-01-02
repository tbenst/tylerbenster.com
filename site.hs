--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid          (mappend)
import Hakyll
import Data.List            (isPrefixOf, isSuffixOf)
import System.FilePath      (takeFileName)
import System.Process       (system)
import Data.Maybe           (fromMaybe)
import Hakyll.Images        (loadImage, compressJpgCompiler, scaleImageCompiler)
import qualified Hakyll.Images.Metadata as M

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/page.html" postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            -- >>= relativizeUrls

    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                -- >>= relativizeUrls

    match "homepage.markdown" $ do
        route $ constRoute "index.html"

        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let homepageCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            pandocCompiler
                >>= loadAndApplyTemplate "templates/homepage.html" homepageCtx
                >>= loadAndApplyTemplate "templates/default.html" homepageCtx
                -- >>= relativizeUrls

    match "papers/*.bib" $ compile biblioCompiler
    match "papers/*.csl" $ compile cslCompiler

    match "writing.markdown" $ do
        route $ setExtension "html"
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let writingCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext
            pandocBiblioCompiler "papers/blog.csl" "papers/research.bib"
                >>= applyAsTemplate writingCtx
                >>= renderPandoc
                >>= loadAndApplyTemplate "templates/page.html" writingCtx
                >>= loadAndApplyTemplate "templates/default.html" writingCtx
                -- >>= relativizeUrls

    match "*.markdown" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            -- >>= relativizeUrls

    match "*.html" $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= applyAsTemplate defaultContext
                >>= loadAndApplyTemplate "templates/page.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                -- >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

    -- copy all static content
    -- https://robertwpearce.com/hakyll-pt-4-copying-static-files-for-your-build.html
    match ("images/*.jpg" .||. "images/*.jpeg") $ do
        route   idRoute
        compile $ do
            i <- loadImage
            s <- imageSize <$> M.imageMetadata i
            if s > (1024*1024)
                then do scaleImageCompiler 1024 1024 i
                    >>= compressJpgCompiler 80
                else return i

    match (  "master.css"
        .||. "images/*.png"
        .||. "media/*") $ do
        route   idRoute
        compile copyFileCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

pagesCompiler :: Identifier -> Context String -> Compiler (Item [Char])
pagesCompiler template context =
    getResourceString >>=
    applyAsTemplate context >>=
    renderPandoc >>=
    loadAndApplyTemplate template context


imageSize :: M.Metadatas -> Word
imageSize m = height * width
    where
        width  = fromMaybe 1 $ M.lookup M.Width m
        height = fromMaybe 1 $ M.lookup M.Height m
--------------------------------------------------------------------------------

config :: Configuration
config = Configuration
    { destinationDirectory = "_site"
    , storeDirectory       = "_cache"
    , tmpDirectory         = "_cache/tmp"
    , providerDirectory    = "static"
    , ignoreFile           = ignoreFile'
    , deployCommand        = "echo 'No deploy command specified' && exit 1"
    , deploySite           = system . deployCommand
    , inMemoryCache        = True
    , previewHost          = "127.0.0.1"
    , previewPort          = 8000
    }
  where
    ignoreFile' path
        | "."    `isPrefixOf` fileName = True
        | "#"    `isPrefixOf` fileName = True
        | "~"    `isSuffixOf` fileName = True
        | ".swp" `isSuffixOf` fileName = True
        | otherwise                    = False
      where
        fileName = takeFileName path
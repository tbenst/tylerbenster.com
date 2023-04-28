--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid          (mappend)
import Hakyll
import Data.List            (isPrefixOf, isSuffixOf)
import System.FilePath      (takeFileName)
import System.Process       (system)
import Data.Maybe           (fromMaybe)
import Hakyll.Images        (loadImage, compressJpgCompiler, scaleImageCompiler)
import Control.Applicative  (empty)
import qualified Hakyll.Images.Metadata as M

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do

    match "posts/*" $ do
        -- idea from https://chungyc.org/article/technical/website/extensionless
        -- alternatively could consider https://alexanderlobov.net/posts/2017-02-05-hakyll-clean-urls/
        -- but instead we rely on nginx to read the .html file for clean urls
        -- https://stackoverflow.com/questions/38228393/nginx-remove-html-extension
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
    
    create ["cal/30-min.html"] $ do
        route idRoute
        compile $ makeItem $ Redirect "https://fantastical.app/tbenst/30-min"

    match "homepage.markdown" $ do
        route $ constRoute "index.html"

        compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/homepage.html" defaultContext
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
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
-- no idea on the type signature here ;)
-- later on when local build fixed, we can try to use this to replace
-- writingCtx and 
-- postListCtx :: _ -> Context String
-- postListCtx posts =
--     listField "posts" postCtx (return posts) `mappend`
--     defaultContext

postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    cleanUrlField `mappend`
    defaultContext

pagesCompiler :: Identifier -> Context String -> Compiler (Item [Char])
pagesCompiler template context =
    getResourceString >>=
    applyAsTemplate context >>=
    renderPandoc >>=
    loadAndApplyTemplate template context

cleanUrlField :: Context a
cleanUrlField = field "cleanurl" $
    fmap (maybe empty $ removeHtmlExtension . toUrl) . getRoute . itemIdentifier

removeHtmlExtension :: String -> String
removeHtmlExtension url = if ".html" `isSuffixOf` url
    then take (length url - 5) url
    else url

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
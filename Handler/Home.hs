{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler RepHtml
getHomeR = do
    (formWidget, formEnctype) <- generateFormPost sampleForm
    let submission = Nothing :: Maybe (FileInfo, Text)
        handlerName = "getHomeR" :: Text
    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Yesod Map!"
        --addStylesheetRemote   "http://localhost/ext-4.2.1/resources/css/ext-all.css"
        addStylesheetRemote   "http://localhost/OpenLayers-2.13/theme/default/style.css"
        addStylesheet $ StaticR javascripts_resources_css_cf_css
        addScriptRemote   "http://localhost/OpenLayers-2.13/OpenLayers.js"
        --addScriptRemote   "http://localhost/ext-4.2.1/ext-debug-w-comments.js"
        addScriptRemote   "http://localhost/ext-4.2.1/examples/shared/include-ext.js"
        addScriptRemote   "http://localhost/ext-4.2.1/examples/shared/options-toolbar.js"
        addScript $ StaticR javascripts_openlayersTiandi_js
        addScript $ StaticR  javascripts_app_js
        addScript $ StaticR javascripts_commonfun_js

        $(widgetFile "homepage")

postHomeR :: Handler RepHtml
postHomeR = do
    ((result, formWidget), formEnctype) <- runFormPost sampleForm
    let handlerName = "postHomeR" :: Text
        submission = case result of
            FormSuccess res -> Just res
            _ -> Nothing

    defaultLayout $ do
        aDomId <- newIdent
        setTitle "Yesod Map"
        $(widgetFile "homepage")

sampleForm :: Form (FileInfo, Text)
sampleForm = renderDivs $ (,)
    <$> fileAFormReq "Choose a file"
    <*> areq textField "What's on the file?" Nothing

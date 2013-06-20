module Handler.Maptree where

import Import

--getMaptreeR :: Handler TypedContent
--getMaptreeR =do
--        selectRep $ do
--                let obj1=object $ (["text" .= ("天地图全国矢量底图"::Text)])
--                let obj2=object $ (["text" .= ("天地图全国矢量图标"::Text)])
--                let temppbj= array $ [obj1,obj2]
--                provideRep $ jsonToRepJson $ object $ (["text" .= ("天地图"::Text),"children" .=temppbj])
getMaptreeR ::  Handler Value
getMaptreeR = return $ object ["text" .= ("天地图"::Text),"children" .= array [object ["text" .= ("天地图全国矢量底图" :: Text)],object ["text" .= ("天地图全国矢量图标" :: Text)]] ]               
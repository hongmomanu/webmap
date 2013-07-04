module Handler.Maptree where

import Import

import qualified Data.Int as Data

--getMaptreeR :: Handler TypedContent
--getMaptreeR =do
--        selectRep $ do
--                let obj1=object $ (["text" .= ("天地图全国矢量底图"::Text)])
--                let obj2=object $ (["text" .= ("天地图全国矢量图标"::Text)])
--                let temppbj= array $ [obj1,obj2]
--                provideRep $ jsonToRepJson $ object $ (["text" .= ("天地图"::Text),"children" .=temppbj])
--getMaptreeR ::  Handler Value
--getMaptreeR = return $ object ["text" .= ("天地图"::Text),"children" .= array [object ["text" .= ("天地图全国矢量底图" :: Text)],object ["text" .= ("天地图全国矢量图标" :: Text)]] ]
getMaptreeR :: Handler Value
getMaptreeR =do
    mapservers <- runDB $ selectList [] [Desc MapserverId]
    maptypes <- sequence [(runDB $ selectList [MaptypeMapowerid ==. mapserverId] [Desc MaptypeId]) | Entity mapserverId mapserver<- (mapservers ::[Entity  Mapserver])]
    let maplist=[object ["text" .= (mapserverOwername mapserver), "updatetime" .=(mapserverUpdatetime mapserver), "expanded" .=True,  
            "children" .=array [object ["text" .= (maptypeMapname maptype),"leaf" .= True]| Entity maptypeId maptype <- (maptypes !! index) :: [Entity  Maptype]]
            ] | ((Entity mapserverId mapserver) ,index)<- zip (mapservers ::[Entity  Mapserver]) [0..]]
    return $ array maplist




module Handler.CurrentStatus where

import Import

import qualified Bussiness.Pattern as Pa

import Data.IORef


getCurrentStatusR :: Handler Value
getCurrentStatusR = do

    statue <-liftIO $ readIORef Pa.patterStatuesVar


    return $ array [object ["table" .= (a!!0),"user" .= (a!!1),"time" .= (a!!2) ,"statue" .= (a!!3) ,
                            "value" .= (a!!4),"over" .= (a!!5),"patterned" .=(a!!6),"similar" .=(a!!7) ,"no" .=(a!!8)]
                            | a<- statue]
{-# LANGUAGE ScopedTypeVariables #-}
module Handler.CheckConnect where

import Import

import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.Text as T


import Control.Exception (handle, SomeException)


postCheckConnectR :: Handler Value
postCheckConnectR = do
    host <- lookupPostParam "host"
    dbname <- lookupPostParam "dbname"
    user <- lookupPostParam "user"
    password <- lookupPostParam "password"
    let paramList=checkUlrFilter host dbname user password
    
    dbh <- liftIO $ handle(\(e :: SomeException) ->  return  (False,(show e,[])))
    									(do  conn <- (connectPostgreSQL ("host="++T.unpack(paramList !! 0) ++" dbname="++T.unpack(paramList !!1)++" user="++T.unpack(paramList !!2)++" password="++T.unpack(paramList !!3)))  
    									     tables <- getTables conn
    									     print  tables
    									     disconnect conn
    									     return (True,("连接成功!",tables)))
    return $ object ["success" .= fst dbh,"msg" .= fst (snd dbh),"tables" .= snd (snd dbh)]
    

--访问瓦片参数过滤
checkUlrFilter host dbname user password =
    let host_param =case host of
                Just "" -> error "host 无值"
                Just info -> info
                Nothing -> error "no host param"
        dbname_param =case dbname of
                Just "" -> error "dbname 无值"
                Just info -> info
                Nothing -> error "no dbname param"
        user_param =case user of
                Just "" -> error "user 无值"
                Just info -> info
                Nothing -> error "no user param"
        password_param =case password of
                Just "" -> error "password 无值"
                Just info -> info
                Nothing -> error "no password param"
        

    in [host_param,dbname_param,user_param,password_param]

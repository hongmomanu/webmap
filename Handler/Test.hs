{-# LANGUAGE ScopedTypeVariables #-}
module Handler.Test where

import Import

import Database.HDBC
import Database.HDBC.ODBC
import Database.HDBC.PostgreSQL


import Control.Exception (handle, SomeException)



getTestR :: Handler Value
getTestR = do
    --liftIO $ print 123
    --let connectionString = "Driver={/opt/instantclient/libsqora.so.11.1};Uid=CIVILAFFAIRS_MZ_TZ_MATCH;Pwd=hvit"
    --let ioconn = connectODBC connectionString
    --conn <- liftIO $ ioconn
    --vals <- liftIO $ quickQuery conn "SELECT count(*) FROM t_doorplate_match" []
    --liftIO $ print vals
    let x = 5 `div` 0
    liftIO $ handle (\(_ :: SomeException) -> print  "muhhaha")  (print x)
    --liftIO $ print x
    dbh <- liftIO $ handle(\(e :: SomeException) ->  return  (False,show e))(connectPostgreSQL "host=192.168.2.141 dbname=gnc user=postgres password=hvit" >> return (True,"连接成功!")) 
    --let dbh=connectPostgreSQL "host=192.168.2.141 dbname=gnc user=postgres password=hvit"
    
    liftIO $ print dbh
    --vals <- liftIO $ handleSqlError $  quickQuery dbh "SELECT count(*) FROM task1" []
    --liftIO $ print vals
    --error "Not yet implemented: getTestR"
    return $ object ["success" .= fst dbh,"msg" .= snd dbh]

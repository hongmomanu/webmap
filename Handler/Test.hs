module Handler.Test where

import Import

import Database.HDBC
import Database.HDBC.ODBC

getTestR :: Handler Html
getTestR = do
    liftIO $ print 123
    let connectionString = "Driver={/opt/instantclient/libsqora.so.11.1};Uid=CIVILAFFAIRS_MZ_TZ_MATCH;Pwd=hvit"
    let ioconn = connectODBC connectionString
    conn <- liftIO $ ioconn
    vals <- liftIO $ quickQuery conn "SELECT count(*) FROM t_doorplate_match" []
    liftIO $ print vals
    error "Not yet implemented: getTestR"

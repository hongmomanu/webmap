module Bussiness.Dbconn
where

import Import

import qualified Bussiness.ConnPool as Pol

import Database.HDBC
import Database.HDBC.ODBC
import Database.HDBC.PostgreSQL
import qualified Data.Text as T

--连接postgis数据库
connectPg   host dbname user password =do
    connPool <- Pol.newConnPool 1 3 (connectPostgreSQL ("host="++ T.unpack(host) ++
                            " dbname="++ T.unpack(dbname) ++" user=" ++ T.unpack(user) ++" password="++ T.unpack(password))) disconnect
    Pol.withConn connPool $ \conn -> do return conn

--连接oracle数据库
connectOracle host dbname user password =do
     connPool <- Pol.newConnPool 1 3 (connectODBC ("Driver={/opt/instantclient/libsqora.so.11.1};Uid="
                            ++ T.unpack(user) ++ ";Pwd=" ++ T.unpack(password) ++";Dbq=" ++ T.unpack(host))) disconnect
     Pol.withConn connPool $ \conn -> do return conn



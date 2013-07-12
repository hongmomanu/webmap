module Bussiness.ConnPool(newConnPool, withConn, delConnPool,takeConn)
where

import Import

import qualified Data.Text as T
import qualified Data.ByteString.Char8 as Bys
import Control.Concurrent
import Control.Exception
import Control.Monad (replicateM)
import Database.HDBC


data Pool a =
    Pool { poolMin :: Int, poolMax :: Int, poolUsed :: Int, poolFree :: [a] }

newConnPool :: Int -> Int -> IO a -> (a -> IO ()) -> IO (MVar (Pool a), IO a, (a -> IO ()))
newConnPool low high newConn delConn = do
--    cs <- handleSqlError . sequence . replicate low newConn
    cs <- replicateM low newConn
    mPool <- newMVar $ Pool low high 0 cs
    return (mPool, newConn, delConn)

delConnPool (mPool, newConn, delConn) = do
    pool <- takeMVar mPool
    if length (poolFree pool) /= poolUsed pool
      then putMVar mPool pool >> fail "pool in use"
      else mapM_ delConn $ poolFree pool

takeConn (mPool, newConn, delConn) = modifyMVar mPool $ \pool ->
    case poolFree pool of
        conn:cs ->
            print "takeConn">>return (pool { poolUsed = poolUsed pool + 1, poolFree = cs }, conn)
        _ | poolUsed pool < poolMax pool -> do
            print "make new Conn"
            conn <- handleSqlError newConn
            return (pool { poolUsed = poolUsed pool + 1 }, conn)
        _ -> fail "pool is exhausted"

putConn :: (MVar (Pool a), IO a, (a -> IO b)) -> a -> IO ()
putConn (mPool, newConn, delConn) conn = modifyMVar_ mPool $ \pool ->
    let used = poolUsed pool in
    if used > poolMin pool
    then handleSqlError ( print "del" >> delConn conn) >> return (pool { poolUsed = used - 1 })
    else return $ pool { poolUsed = used - 1, poolFree = conn : (poolFree pool) }

withConn connPool = bracket (takeConn connPool) (putConn connPool)

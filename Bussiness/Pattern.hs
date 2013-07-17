module Bussiness.Pattern
where

import Import

import Database.HDBC

import qualified Data.Text as T

import Data.String.Unicode
--import Data.ByteString.UTF8 (fromString)
--import qualified Data.ByteString.Char8 as Char8
import qualified Codec.Text.IConv as IConv

--import Text.Regex.Posix
import Bussiness.SimpleRegex

patternBegin prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type =do
    case (prop_type,space_type) of ("1","1") -> do print 1
                                                   patternOrcl_Orcl (snd prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type

                                   ("1","0") -> do print 2
                                                   patternOrcl_Pg (snd prop_conn) (fst space_conn) prop_table space_table prop_limit space_limit prop_type space_type
    print "ok"


patternOrcl_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type =
    do

        let prop_sql="SELECT  id , DOORPLATE FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        print "begin"
        vals <- quickQuery'   prop_conn_action prop_sql []
        print vals
        let stringRows = map convRow vals
        print stringRows


        let test_sql="SELECT count(*) FROM "++ T.unpack(prop_table) ++ "  " ++ " where doorplate like '%"++  stringRows !! 0 ++ "%'"
        --print test_sql
        testvals <- quickQuery prop_conn_action test_sql []
        print testvals

        print "all right"
    where convRow :: [SqlValue] -> String
          convRow [sqlId, sqlDesc] =
                  desc
                  where intid = (fromSql sqlId)::Integer
                        desc = case fromSql sqlDesc of
                                 Just x -> x
                                 Nothing -> "NULL"
          convRow x = fail $ "Unexpected result: " ++ show x




patternOrcl_Pg prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type =
    do
        let space_sql="SELECT '路','路' FROM "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit)
        space_conn_action <- space_conn
        vals <- quickQuery space_conn_action space_sql []
        let stringRows = map convRow vals
        print  (stringRows !! 0)
        print stringRows
    where convRow :: [SqlValue] -> String
          convRow [sqlId, sqlDesc] =
                  desc
                  where intid = (fromSql sqlId)::Integer
                        desc = case fromSql sqlDesc of
                                 Just x -> x
                                 Nothing -> "NULL"
          convRow x = fail $ "Unexpected result: " ++ show x


splitDoorplate doorplate=do
    print "ok"
    --let pat = "([0-9０-９|甲乙丙丁东南西北——|-]+(号|室))"

    --getAllTextMatches $  "安平北路161号鸿溪花园一单元203室" =~ pat :: [String]



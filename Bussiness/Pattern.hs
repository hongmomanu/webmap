{-# LANGUAGE ScopedTypeVariables #-}
module Bussiness.Pattern
where

import Import

import Database.HDBC
import Prelude

import qualified Data.Text as T (unpack)
import qualified Data.ByteString.Lazy as L (ByteString,empty)
import Data.Array (elems)

--import Data.String.Unicode
--import Data.ByteString.UTF8 (fromString)
--import qualified Data.ByteString.Char8 as Char8
--import qualified Codec.Text.IConv as IConv

--import Text.Regex.Posix
import Text.Regex.TDFA
import CommonFun.ListFunc  as LF

patternBegin prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit=do
    case (prop_type,space_type) of ("1","1") -> do print "orcl to orcl"
                                                   patternOrcl_Orcl (snd prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type issplit
                                                   --else (getOrcl_Orcl (snd prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type)

                                   ("1","0") -> do print "orcl to pg"
                                                   patternOrcl_Pg (snd prop_conn) (fst space_conn) prop_table space_table prop_limit space_limit prop_type space_type  issplit
                                                   --                     else (getOrcl_Pg (snd prop_conn) (fst space_conn) prop_table space_table prop_limit space_limit prop_type space_type)
                                   ("0","1") -> do print "pg to orcl"
                                                   patternPg_Orcl (fst prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type   issplit
                                                   --                     else (getPg_Orcl (fst prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type)


    print "done"

--分解门牌
patternToList doorplate=
    do
        doornum <- splitDoorplate doorplate
        mainroad <- splitDoorplateMainRoad doorplate
        village <- splitDoorplateVillage doorplate
        secroad <- splitDoorplateSecRoad doorplate

        build <- splitDoorplateBuild doorplate
        cell <- splitDoorplateCell doorplate

        return [if (length (map elems doornum) >0 ) then (map (\[(a,b)] -> LF.slice a b doorplate ) (map elems doornum)) else ([])
                ,if (length (map elems mainroad) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems mainroad)))  else ([])
                ,if (length (map elems village) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems village)))  else ([])
                ,if (length (map elems secroad) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems secroad)))  else ([])
                ,if (length (map elems build) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems build)))  else ([])
                ,if (length (map elems cell) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems cell)))  else ([])

                ]




--门牌地址过滤 返回[主要道路，村社区，居民点，次要道路，楼号，单元，门牌1，门牌2]
patternFilter doorlist doorplate=
    let doornum1=if(length (doorlist !! 0) >0) then ( head (doorlist !!0) ) else ("")
        doornum2=if(length (doorlist !! 0) >1) then ( last (doorlist !!0) ) else ("")

        mainroad=if(length (doorlist!! 1) > 0) then (head (doorlist !! 1)) else ("")

        village =if(length (doorlist!! 2) > 0)  then (LF.replaceList [mainroad,doornum1,doornum2] "" (head (doorlist !! 2)) ) else ("")
        secroad = if(length (doorlist!! 3) > 0) then (LF.replaceList [village,mainroad,doornum1,doornum2] "" (head (doorlist !! 3)))  else ("")

        build=if(length (doorlist !! 4) >0) then ( head (doorlist !!4) ) else ("")
        cell =if(length (doorlist !! 5 )>0) then ( head (doorlist !!5) ) else ("")

        --jmd =if(length doorplate > 0) then (LF.replace cell "" (LF.replace build "" (LF.replace secroad "" (LF.replace village "" (LF.replace mainroad "" doorplate) )))) else ("")
        jmd =if(length doorplate>0)then (LF.replaceList [doornum1,doornum2,mainroad,village,secroad,build,cell] "" doorplate) else ("")

    in  [mainroad,village,jmd,secroad, build,cell,doornum1,doornum2]


--保存分解的门牌数据

saveSplitDoorplate doorplatelist prop_conn_action prop_table rowid=do

    let update_sql="update " ++ prop_table ++ "  set 主要道路=?,村社区=?,居民点=?,次要道路=?,楼栋号=?,单元号=?,门牌1=?,门牌2=?  where id=? "
    let string_value=[toSql a | a <- doorplatelist ]
    let int_value=[toSql rowid]
    let sql_values=string_value ++ int_value
    print sql_values
    run prop_conn_action  update_sql sql_values
    commit prop_conn_action


--保存分解到postgis数据

saveSplitDoorplatePg doorplatelist prop_conn_action prop_table rowid=do

    let update_sql="update " ++ prop_table ++ "  set \"主要道路\"=?,\"村社区\"=?,\"居民点\"=?,\"次要道路\"=?,\"楼栋号\"=?,\"单元号\"=?,\"门牌1\"=?,\"门牌2\"=?  where id=? "
    let string_value=[toSql a | a <- doorplatelist ]
    let int_value=[toSql rowid]
    let sql_values=string_value ++ int_value
    print sql_values
    run prop_conn_action  update_sql sql_values
    commit prop_conn_action



--获取已经分解的门牌数据并进行匹配
getOrcl_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type =
    do

        let prop_sql="SELECT  id,主要道路 , 村社区,居民点,次要道路,楼栋号,单元号,门牌1,门牌2 FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        vals <- quickQuery   prop_conn_action prop_sql []
        let stringRows = map convRow vals
        print stringRows
        print "all right"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlroad,sqlvillage,sqljmd,sqlsecroad,sqlbuild,sqlcell,sqldoor1,sqldoor2] =
                  [intid,road,village,jmd,secroad,build,cell,door1,door2]
                  where intid = (fromSql sqlId)::String
                        road    = case fromSql sqlroad of
                                    Just x -> x
                                    Nothing -> ""

                        village = case fromSql sqlvillage of
                                    Just "null" -> ""
                                    Just x -> x
                                    Nothing -> ""

                        jmd =case fromSql sqljmd of
                                 Just "null" -> ""
                                 Just x -> x
                                 Nothing -> ""
                        secroad =case fromSql sqlsecroad of
                                 Just "null" -> ""
                                 Just x -> x
                                 Nothing -> ""
                        build =case fromSql sqlbuild of
                                 Just "null" -> ""
                                 Just x -> x
                                 Nothing -> ""
                        cell=case fromSql sqlcell of
                                  Just "null" -> ""
                                  Just x -> x
                                  Nothing -> ""
                        door1=case fromSql sqldoor1 of
                                  Just "null" -> ""
                                  Just x -> x
                                  Nothing -> ""
                        door2=case fromSql sqldoor2 of
                                   Just "null" -> ""
                                   Just x -> x
                                   Nothing -> ""

          convRow x = fail $ "Unexpected result: " ++ show x


--根据行数据进行匹配

makePatternOrcl rowdata space_conn space_limit space_table=
    do
        let patternlimit_sql=" and (主要道路=? or 村社区=? or 居民点=? or 次要道路=?)"
        let sql="select id, mapguid,楼栋号,单元号,门牌1,门牌2 from "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit) ++ patternlimit_sql
        space_conn_action <- space_conn
        vals <- quickQuery   space_conn_action sql []
        let stringRows = map convRow vals




        print "done"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlguid,sqlbuild,sqlcell,sqldoor1,sqldoor2] =
                  [intid,guid,build,cell,door1,door2]
                  where intid = (fromSql sqlId)::String
                        guid    = case fromSql sqlguid of
                                    Just x -> x
                                    Nothing -> ""
                        build =case fromSql sqlbuild of
                                 Just x -> x
                                 Nothing -> ""
                        cell=case fromSql sqlcell of
                                  Just x -> x
                                  Nothing -> ""
                        door1=case fromSql sqldoor1 of
                                  Just x -> x
                                  Nothing -> ""
                        door2=case fromSql sqldoor2 of
                                   Just x -> x
                                   Nothing -> ""

          convRow x = fail $ "Unexpected result: " ++ show x




--获取已经分解的门牌数据并进行匹配

getPg_splitdoorplate prop_conn  prop_table  prop_limit  =
    do

        let prop_sql="SELECT  gid,\"主要道路\" , \"村社区\",\"居民点\",\"次要道路\",\"楼栋号\",\"单元号\",\"门牌1\",\"门牌2\" FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        vals <- quickQuery   prop_conn_action prop_sql []
        let stringRows = map convRow vals
        return stringRows
        --print "all right"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlroad,sqlvillage,sqljmd,sqlsecroad,sqlbuild,sqlcell,sqldoor1,sqldoor2] =
                  [intid,road,village,jmd,secroad,build,cell,door1,door2]
                  where intid = (fromSql sqlId)::String
                        road    = case fromSql sqlroad of
                                    Just x -> x
                                    Nothing -> ""

                        village = case fromSql sqlvillage of
                                    Just x -> x
                                    Nothing -> ""

                        jmd =case fromSql sqljmd of
                                 Just x -> x
                                 Nothing -> ""
                        secroad =case fromSql sqlsecroad of
                                 Just x -> x
                                 Nothing -> ""
                        build =case fromSql sqlbuild of
                                 Just x -> x
                                 Nothing -> ""
                        cell=case fromSql sqlcell of
                                  Just x -> x
                                  Nothing -> ""
                        door1=case fromSql sqldoor1 of
                                  Just x -> x
                                  Nothing -> ""
                        door2=case fromSql sqldoor2 of
                                   Just x -> x
                                   Nothing -> ""

          convRow x = fail $ "Unexpected result: " ++ show x






--获取已经分解的门牌数据并进行匹配
getOrcl_Pg prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type =
    do

        let prop_sql="SELECT  id,主要道路 , 村社区,居民点,次要道路,楼栋号,单元号,门牌1,门牌2 FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        vals <- quickQuery   prop_conn_action prop_sql []
        let stringRows = map convRow vals

        print "all right"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlroad,sqlvillage,sqljmd,sqlsecroad,sqlbuild,sqlcell,sqldoor1,sqldoor2] =
                  [intid,road,village,jmd,secroad,build,cell,door1,door2]
                  where intid = (fromSql sqlId)::String
                        road    = case fromSql sqlroad of
                                    Just x -> x
                                    Nothing -> ""

                        village = case fromSql sqlvillage of
                                    Just x -> x
                                    Nothing -> ""

                        jmd =case fromSql sqljmd of
                                 Just x -> x
                                 Nothing -> ""
                        secroad =case fromSql sqlsecroad of
                                 Just x -> x
                                 Nothing -> ""
                        build =case fromSql sqlbuild of
                                 Just x -> x
                                 Nothing -> ""
                        cell=case fromSql sqlcell of
                                  Just x -> x
                                  Nothing -> ""
                        door1=case fromSql sqldoor1 of
                                  Just x -> x
                                  Nothing -> ""
                        door2=case fromSql sqldoor2 of
                                   Just x -> x
                                   Nothing -> ""

          convRow x = fail $ "Unexpected result: " ++ show x






--重新分解门牌数据并进行匹配
patternOrcl_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit =
    do

        let prop_sql="SELECT  id , DOORPLATE FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        print "begin"
        vals <- quickQuery  prop_conn_action prop_sql []
        let stringRows = map convRow vals

        --let doorplate = "江滨东路23号江湖新村金色华庭车库一单元9幢11号" :: String
        let doorplate = snd (head stringRows)
        testarr <- patternToList  doorplate

        let filter_list=patternFilter testarr  doorplate
        print doorplate
        print filter_list

        saveSplitDoorplate filter_list prop_conn_action (T.unpack prop_table) (fst (head stringRows))


        print "all right"
    where convRow :: [SqlValue] -> (Integer,String)
          convRow [sqlId, sqlDoorplate] =
                  (rid,doorplate)
                  where rid = (fromSql sqlId)::Integer
                        doorplate = case fromSql sqlDoorplate of
                                 Just x -> x
                                 Just "null" -> ""
                                 Nothing -> ""
--          convRow x = fail $ "Unexpected result: " ++ show x

--单个数据相似匹配
similarOrcl_Pg list prop_table prop_conn_action=do
    print "not done"


--单个数据更新orcl
saveRowSplitOrcl  rowdata table conn_action=do
    print "save begin"
    let doorplate = snd (rowdata)
    testarr <- patternToList  doorplate
    let filter_list=patternFilter testarr  doorplate
    saveSplitDoorplate filter_list conn_action (T.unpack table) (fst rowdata)

--单个数据更新postgres
saveRowSplitPg  rowdata table conn_action=do
    let doorplate = snd (rowdata)
    testarr <- patternToList  doorplate
    let filter_list=patternFilter testarr  doorplate
    saveSplitDoorplatePg filter_list conn_action (T.unpack table) (fst rowdata)



getPgpatternControl issplit pg_conn table limit = do
    case issplit of "true"  -> do let sql="SELECT gid , doorplate FROM "++ T.unpack(table) ++ "  " ++ T.unpack(limit)
                                  pg_conn_action <- pg_conn
                                  vals <- quickQuery pg_conn_action sql []
                                  let stringRows = map convRow vals
                                  print  stringRows
                                  sequence [saveRowSplitPg  rowdata table pg_conn_action | rowdata <- stringRows]
                                  print "save split over"
                               where convRow :: [SqlValue] -> (Integer,String)
                                     convRow [sqlId, sqlDoorplate] =
                                             (rid,doorplate)
                                             where rid = (fromSql sqlId)::Integer
                                                   doorplate = case fromSql sqlDoorplate of
                                                            Just x -> x
                                                            Just "null" -> ""
                                                            Nothing -> ""





                    "false" -> do print "get data"


getOrclpatternControl issplit orcl_conn table limit = do
    case issplit of "true"  -> do let sql="SELECT id , doorplate FROM "++ T.unpack(table) ++ "  " ++ T.unpack(limit)
                                  orcl_conn_action <- orcl_conn
                                  vals <- quickQuery orcl_conn_action sql []
                                  let stringRows = map convRow vals
                                  print  stringRows
                                  sequence [saveRowSplitOrcl  rowdata table orcl_conn_action | rowdata <- stringRows]
                                  print "save split over"
                               where convRow :: [SqlValue] -> (Integer,String)
                                     convRow [sqlId, sqlDoorplate] =
                                             (rid,doorplate)
                                             where rid = (fromSql sqlId)::Integer
                                                   doorplate = case fromSql sqlDoorplate of
                                                            Just x -> x
                                                            Just "null" -> ""
                                                            Nothing -> ""





                    "false" -> do print "just get data"


--postgis向orcl查询分解数据并匹配
patternPg_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit =
    do
        --let doornum1=if(length (doorlist !! 0) >0) then ( head (doorlist !!0) ) else ("")

        --let prop_sql="SELECT gid , doorplate FROM "++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        --prop_conn_action <- prop_conn
        --vals <- quickQuery prop_conn_action prop_sql []
        --let stringRows = map convRow vals
        --sequence [saveRowSplitPg  rowdata prop_table prop_conn_action | rowdata <- stringRows ]
        getPgpatternControl (issplit!!0)  prop_conn prop_table prop_limit
        print "after pg patter"
        getOrclpatternControl (issplit!!1)  space_conn  space_table  space_limit
        print "after orcle patter"

        --let stringRows_pg=getPg_splitdoorplate prop_conn  prop_table  prop_limit

        print "after pattern and save"
        --let space_sql="SELECT id , doorplate FROM "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit)
        --space_conn_action <- space_conn
        --space_vals <- quickQuery space_conn_action space_sql []
        --let stringRows_space = map convRow space_vals
        --print  stringRows_space

        --sequence [saveRowSplitOrcl  rowdata space_table space_conn_action | rowdata <- stringRows_space ]


        print "done"



--orcl向postgis查询分解数据并匹配
patternOrcl_Pg prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit=
    do
        let prop_sql="SELECT id , doorplate FROM "++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn
        vals <- quickQuery prop_conn_action prop_sql []
        let stringRows = map convRow vals
        sequence [saveRowSplitOrcl  rowdata prop_table prop_conn_action | rowdata <- stringRows ]


        let space_sql="SELECT gid , doorplate FROM "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit)
        space_conn_action <- space_conn
        space_vals <- quickQuery space_conn_action space_sql []
        let stringRows_space = map convRow space_vals

        sequence [saveRowSplitPg  rowdata prop_table prop_conn_action | rowdata <- stringRows_space ]


        print "done"

    where convRow :: [SqlValue] -> (Integer,String)
          convRow [sqlId, sqlDoorplate] =
                  (rid,doorplate)
                  where rid = (fromSql sqlId)::Integer
                        doorplate = case fromSql sqlDoorplate of
                                 Just x -> x
                                 Just "null" -> ""
                                 Nothing -> ""


--分出门牌号
splitDoorplate doorplate=do
    --let name ="纹二路120号中天大厦一单元24甲室"::String
    let regex ="[0-9A-Z一二三四五六七八九十东南西北甲乙丙丁]+[号室]"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出主要道路
splitDoorplateMainRoad doorplate=do
    --let name ="台品街道纹二大道120号中天大厦一单元24甲室"::String
    let regex=".+(路|大道|街|街道)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出村社区
splitDoorplateVillage doorplate =do
    let regex=".+(村|居|小区|花园|社区|苑|公寓|墩|堂村|堂)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出次要道路
splitDoorplateSecRoad doorplate =do
    let regex=".+(弄|里|巷)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出单元号
splitDoorplateCell doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十-]+单元" ::String
    return ( doorplate =~ regex :: [MatchArray])

--分出楼栋号
splitDoorplateBuild doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十-]+(栋|幢|楼|号楼)" ::String
    return ( doorplate =~ regex :: [MatchArray])

--分出居民点
splitDoorplateJmd doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十-]+单元" ::String
    return ( doorplate =~ regex :: [MatchArray])



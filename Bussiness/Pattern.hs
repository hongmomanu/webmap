{-# LANGUAGE ScopedTypeVariables #-}
module Bussiness.Pattern
where

import Import

import Database.HDBC
import Prelude

import qualified Data.Text as T (unpack,pack)
import qualified Data.ByteString.Lazy as L (ByteString,empty)
import Data.Array (elems)

import Control.Concurrent

--import Data.String.Unicode
--import Data.ByteString.UTF8 (fromString)
--import qualified Data.ByteString.Char8 as Char8
--import qualified Codec.Text.IConv as IConv

--import Text.Regex.Posix
import Text.Regex.TDFA
import CommonFun.ListFunc  as LF
import Data.List

import Data.Global
import Data.IORef

patterStatuesVar:: IORef [[Text]]
patterStatuesVar = declareIORef "patterStatuesVar" []



patternBegin prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit mainkey time=do
    let keys=[T.unpack a |a<-mainkey]



    case (prop_type,space_type) of ("1","1") -> do print "orcl to orcl"
                                                   patternOrcl_Orcl (snd prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type issplit keys time
                                                   --else (getOrcl_Orcl (snd prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type)

                                   ("1","0") -> do print "orcl to pg"
                                                   --patternOrcl_Pg (snd prop_conn) (fst space_conn) prop_table space_table prop_limit space_limit prop_type space_type  issplit keys  time
                                                   --                     else (getOrcl_Pg (snd prop_conn) (fst space_conn) prop_table space_table prop_limit space_limit prop_type space_type)
                                   ("0","1") -> do print "pg to orcl"
                                                   patternPg_Orcl (fst prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type   issplit keys  time
                                                   --                     else (getPg_Orcl (fst prop_conn) (snd space_conn) prop_table space_table prop_limit space_limit prop_type space_type)


    print "done"

--分解门牌
patternToList doorplate=
    do
        doornum <- splitDoorplate doorplate
        --print doornum

        mainroad <- splitDoorplateMainRoad doorplate

        village <- splitDoorplateVillage doorplate
        let village_index=map (\[(a,b),(c,d)] -> [a,b]) (map elems village)

        let road_index=map (\[(a,b),(c,d)] -> [a,b]) (map elems mainroad)




        let mainroad_arr=if((length village_index) >0)then (if (length (map elems mainroad) >0 ) then (map (\[(a,b),(c,d)] -> if((a+b)/=(head(head village_index)))then(LF.slice a b doorplate)else("") ) (map elems mainroad))  else ([]))
                                                      else(if (length (map elems mainroad) >0 ) then (map (\[(a,b),(c,d)] -> LF.slice a b doorplate) (map elems mainroad))  else ([]))

        --let village_arr=if (length (map elems village) >0 ) then (map (\[(a,b),(c,d)] -> if()LF.slice 0 (a+b) doorplate ) (map elems village))  else ([])
        --print (map elems village)


        let mainroad1=if(length mainroad_arr > 0) then (head mainroad_arr) else ("")
        let village_arr=if((length road_index) >0)then (if (length (map elems village) >0 ) then (map (\[(a,b),(c,d)] -> if((a+b)/=(head(head road_index)))then(LF.slice 0 (a+b) doorplate)else("") ) (map elems village))  else ([]))
                                                                              else(if (length (map elems village) >0 ) then (map (\[(a,b),(c,d)] -> LF.slice 0 (a+b) doorplate) (map elems village))  else ([]))

        let mainroad2=if(length mainroad_arr > 1) then (last mainroad_arr) else ("")
        let mainroad_str= if(mainroad2=="")then(mainroad1)else(LF.replaceList [mainroad1] "" mainroad2)
        --let doorplate_temp =LF.replaceList [if(mainroad2=="")then(mainroad_str)else(LF.replaceList ["社区","新村"] "" mainroad_str)] "" doorplate


        --village <- splitDoorplateVillage doorplate_temp
        secroad <- splitDoorplateSecRoad doorplate


        --print  village_arr

        build <- splitDoorplateBuild doorplate
        cell <- splitDoorplateCell doorplate
        --if (length (map elems village) >1 ) then (LF.slice head(head (map elems village)) (a+b) doorplate)  else ([])
        --if (length (map elems village) >0 ) then (map (\[(a,b),(c,d)] -> LF.slice 0 (a+b) doorplate ) (map elems village))  else ([])
        return [if (length (map elems doornum) >0 ) then (map (\[(a,b)] -> LF.slice a b doorplate ) (map elems doornum)) else ([])
                ,[mainroad_str]
                , village_arr
                ,if (length (map elems secroad) >0 ) then (map (\[(a,b),(c,d)] -> LF.slice 0 (a+b) doorplate ) (map elems secroad))  else ([])
                ,if (length (map elems build) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems build)))  else ([])
                ,if (length (map elems cell) >0 ) then (map (\(a,b) -> LF.slice a b doorplate ) (head (map elems cell)))  else ([])

                ]




--门牌地址过滤 返回[主要道路，村社区，居民点，次要道路，楼号，单元，门牌1，门牌2]
patternFilter doorlist doorplate=
    let doornum1=if(length (doorlist !! 0) >0) then ( head (doorlist !!0) ) else ("")
        doornum2=if(length (doorlist !! 0) >1) then ( last (doorlist !!0) ) else ("")

        --mainroad1=if(length (doorlist!! 1) > 0) then (head (doorlist !! 1)) else ("")
        --mainroad2=if(length (doorlist!! 1) > 1) then (last (doorlist !! 1)) else ("")
        --mainroad= if(mainroad2=="")then(mainroad1)else(LF.replaceList [mainroad1] "" mainroad2)
        mainroad= head(doorlist !! 1)

        --village1 =if(length (doorlist!! 2) > 0)  then (LF.replaceList [mainroad,doornum1,doornum2] "" (head (doorlist !! 2)) ) else ("")
        --village2 =if(length (doorlist!! 2) > 1)  then (LF.replaceList [mainroad,doornum1,doornum2] "" (last (doorlist !! 2)) ) else ("")
        --village = if(village2=="")then(village1)else(LF.replaceList [village1] "" village2)
        village =if(length (doorlist!! 2) > 0)  then (LF.replaceList [mainroad,doornum1,doornum2] "" (head (doorlist !! 2)) ) else ("")

        --secroad1 = if(length (doorlist!! 3) > 0) then (LF.replaceList [village,mainroad,doornum1,doornum2] "" (head (doorlist !! 3)))  else ("")
        --secroad2 = if(length (doorlist!! 3) > 1) then (LF.replaceList [village,mainroad,doornum1,doornum2] "" (last (doorlist !! 3)))  else ("")
        --secroad = if(secroad2=="")then(secroad1)else(LF.replaceList [secroad1] "" secroad2)
        secroad = if(length (doorlist!! 3) > 0) then (LF.replaceList [village,mainroad,doornum1,doornum2] "" (head (doorlist !! 3)))  else ("")
        build=if(length (doorlist !! 4) >0) then ( head (doorlist !!4) ) else ("")
        cell =if(length (doorlist !! 5 )>0) then ( head (doorlist !!5) ) else ("")

        --jmd =if(length doorplate > 0) then (LF.replace cell "" (LF.replace build "" (LF.replace secroad "" (LF.replace village "" (LF.replace mainroad "" doorplate) )))) else ("")
        jmd =if(length doorplate>0)then (LF.replaceList [doornum1,doornum2,mainroad,village,secroad,build,cell] "" doorplate) else ("")

    in  [mainroad,village,jmd,secroad, build,cell,doornum1,doornum2]


--保存分解的门牌数据

saveSplitDoorplate doorplatelist prop_conn_action prop_table rowid maikey=do

--id,主要道路 , 村社区,居民点,次要道路,楼栋号,单元号,门牌1,门牌2
    let update_sql="update " ++ prop_table ++ "  set 主要道路=?,村社区=?,居民点=?,次要道路=?,楼栋号=?,单元号=?,门牌1=?,门牌2=?  where "++maikey++"=? "
    let string_value=[toSql a | a <- doorplatelist ]
    let int_value=[toSql rowid]
    let sql_values=string_value ++ int_value
    print sql_values
    print update_sql
    run prop_conn_action  update_sql sql_values
    commit prop_conn_action


--保存分解到postgis数据

saveSplitDoorplatePg doorplatelist prop_conn_action prop_table rowid maikey=do

    let update_sql="update \"" ++ prop_table ++ "\"  set \"主要道路\"=?,\"村社区\"=?,\"居民点\"=?,\"次要道路\"=?,\"楼栋号\"=?,\"单元号\"=?,\"门牌1\"=?,\"门牌2\"=? ,updatetime=now() where "++maikey++"=? "
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
        --print stringRows
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

--评分确定关联
makeFlag rows rowdata=do
                                                          --LF.replaceList [doornum1,doornum2,mainroad,village,secroad,build,cell] "" doorplate
    let build_list=[row | row <- rows, (LF.replaceList ["栋","幢","楼","号楼"] "" (row !! 2))  == (LF.replaceList ["栋","幢","楼","号楼"] "" (rowdata!! 5))]
    let door_list=[row | row <- rows, (row !! 4)  == (rowdata!! 7) || (if((LF.replaceList ["号"] "" ((LF.splitList "-,－" (row !! 4) )!!0 ::String))  ==((LF.replaceList ["号"] "" ((LF.splitList "-,－" (rowdata!! 7) )!!0))) )then(True)else(False))]

    --sequence [(print ((LF.splitList "-,－" (row !! 4))!!0)) | row <- rows]
    --print ((LF.splitList "-,－" (rowdata!! 7) ) !!0)

    if ((rowdata!! 5)=="") then (if ((length door_list) >= 1) then (if((length door_list) == 1)then((3,door_list))else((1,door_list))) else ((2,[]))) else (
                                        if ((length build_list) >= 1) then (if((length build_list) == 1)then((3,build_list))else((1,build_list))) else ((2,[]))
                                        )


--评分确定关联
makeFlagControl rows rowdata = do
    --print ((LF.splitList "-,－" (rowdata!! 7) ) !! 0)
    --sequence [print ((LF.splitList "-,－" (row !! 4)) !! 0) | row <- rows]
    --print rows
    if ((length rows)==0) then (return (0,[])) else (return (makeFlag rows rowdata) )



--更新pg数据库flag
updatePgflag flag table mapguid gid conn_action mainkey=do
    let update_sql="update \"" ++ T.unpack(table) ++ "\"  set workid=?,flag=?,updatetime=now()  where "++mainkey++"="++gid
    let string_value=[toSql mapguid ,toSql flag]

    --print string_value
    print update_sql
    run conn_action  update_sql string_value
    commit conn_action

--更新Orcl数据库flag
updateOrclflag flag table mapguid gid conn_action mainkey=do
    let update_sql="update " ++ T.unpack(table) ++ "  set workid=?,flag=?  where "++mainkey++"="++gid
    let string_value=[toSql mapguid ,toSql flag]

    --print string_value
    print update_sql
    run conn_action  update_sql string_value
    commit conn_action

--更新orcl数据库mapid
updateOrclmapid  table mapid rid conn_action=do
    let update_sql="update " ++ T.unpack(table) ++ "  set mapid=?  where id= " ++ rid
    print update_sql
    let string_value=[toSql mapid ]

    print string_value

    run conn_action  update_sql string_value
    commit conn_action

--更新orcl数据库mapid测试
updateOrclmapidtest  table mapid rid conn_action mainkey=do
    let update_sql="update " ++ T.unpack(table) ++ "  set mapid=?  where "++ mainkey ++" in (" ++ rid ++ ")"
    let string_value=[toSql mapid ]
    run conn_action  update_sql string_value
    commit conn_action
    print update_sql
    --print string_value



--保存匹配结果
savePatternResultOrcl_Orcl flag pgid table_root table_search prop_conn_action space_conn_action uid mainkey=do
    case (fst flag) of 0 -> do updateOrclflag (fst flag) table_root (""::String) pgid prop_conn_action (mainkey!!0)
                       1 -> do print "begin"
                               let rowids=[head row | row <- (snd flag)]
                               let rowids_str=intercalate "," rowids
                               --print rowids_str
                               --print "123,456,123"
                               updateOrclmapidtest table_search uid rowids_str space_conn_action (mainkey!!1)
                               --sequence [updateOrclmapidtest table_search uid (head row) space_conn_action | row <- (snd flag)]
                               --a <- sequence [updateOrclmapid table_search uid (head row) space_conn_action | row <- (snd flag)]
                               updateOrclflag (fst flag) table_root ((head(snd flag))!!1)  pgid prop_conn_action  (mainkey!!0)
                       2 -> do updateOrclflag (fst flag) table_root (""::String) pgid prop_conn_action (mainkey!!0)
                       3 -> do updateOrclflag (fst flag) table_root ((head(snd flag))!!1) pgid prop_conn_action (mainkey!!0)


--    case (fst flag) of 0 -> do updatePgflag 0 table_root "" pgid prop_conn_action
--                    of 1 -> do print 1
--                               updatePgflag 1 table_root "" pgid prop_conn_action
--                               sequence [updateOrclmapid (last row) pgid space_conn_action | row <- (snd flag)]
--                    of 2 -> do updatePgflag 2 table_root "" pgid prop_conn_action
--                    of 3 -> do updatePgflag 3 table_root ((head(snd flag))!!1) pgid prop_conn_action




--保存匹配结果
savePatternResult flag pgid table_root table_search prop_conn_action space_conn_action uid mainkey=do
    case (fst flag) of 0 -> do updatePgflag (fst flag) table_root (""::String) pgid prop_conn_action (mainkey!!0)
                       1 -> do print "begin"
                               let rowids=[head row | row <- (snd flag)]
                               let rowids_str=intercalate "," rowids
                               --print rowids_str
                               --print "123,456,123"
                               updateOrclmapidtest table_search uid rowids_str space_conn_action (mainkey!!1)
                               --sequence [updateOrclmapidtest table_search uid (head row) space_conn_action | row <- (snd flag)]
                               --a <- sequence [updateOrclmapid table_search uid (head row) space_conn_action | row <- (snd flag)]
                               updatePgflag (fst flag) table_root ((head(snd flag))!!1)  pgid prop_conn_action (mainkey!!0)
                       2 -> do updatePgflag (fst flag) table_root (""::String) pgid prop_conn_action (mainkey!!0)
                       3 -> do updatePgflag (fst flag) table_root ((head(snd flag))!!1) pgid prop_conn_action (mainkey!!0)


--    case (fst flag) of 0 -> do updatePgflag 0 table_root "" pgid prop_conn_action
--                    of 1 -> do print 1
--                               updatePgflag 1 table_root "" pgid prop_conn_action
--                               sequence [updateOrclmapid (last row) pgid space_conn_action | row <- (snd flag)]
--                    of 2 -> do updatePgflag 2 table_root "" pgid prop_conn_action
--                    of 3 -> do updatePgflag 3 table_root ((head(snd flag))!!1) pgid prop_conn_action



--根据行数据进行匹配 orcl-orcl
makePatternOrcl_Orcl rowdata space_conn_action space_limit space_table prop_conn_action prop_table mainkey time totalnum=

    do
        let patternlimit_sql=" and (主要道路=? or 村社区=? or 居民点=? or 次要道路=?)"
        let sql="select "++(mainkey !!1) ++", mapguid,楼栋号,单元号,门牌1,门牌2 from "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit) ++ patternlimit_sql
        --space_conn_action <- space_conn

        --prop_conn_action <- prop_conn
        let sql_value=[toSql (rowdata!!1) , toSql (rowdata!!2) , toSql (rowdata!!3) ,toSql (rowdata!!4) ]

        vals <- quickQuery   space_conn_action sql sql_value

        let stringRows = map convRow vals
        flag::(Int,[[String]]) <- makeFlagControl stringRows  rowdata



        --print  flag
        savePatternResultOrcl_Orcl flag  (rowdata!!0)  prop_table space_table  prop_conn_action space_conn_action  (last rowdata) mainkey


        splitStatue  totalnum time prop_table "匹配数据"
        --return stringRows


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










--根据行数据进行匹配 pg-orcl

makePatternOrcl rowdata space_conn_action space_limit space_table prop_conn_action prop_table mainkey time totalnum=
    do
        let patternlimit_sql=" and (主要道路=? or 村社区=? or 居民点=? or 次要道路=?)"
        let sql="select "++ (mainkey !!1) ++", mapguid,楼栋号,单元号,门牌1,门牌2 from "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit) ++ patternlimit_sql
        --space_conn_action <- space_conn

        --prop_conn_action <- prop_conn
        let sql_value=[toSql (rowdata!!1) , toSql (rowdata!!2) , toSql (rowdata!!3) ,toSql (rowdata!!4) ]

        vals <- quickQuery   space_conn_action sql sql_value

        let stringRows = map convRow vals
        flag::(Int,[[String]]) <- makeFlagControl stringRows  rowdata

        --print  flag



        savePatternResult flag  (rowdata!!0)  prop_table space_table  prop_conn_action space_conn_action  (last rowdata) mainkey

        splitStatue  totalnum time prop_table "匹配数据"

        --return stringRows

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

getPg_splitdoorplate prop_conn  prop_table  prop_limit  mainkey=
    do
        --print "ooo"
        --print prop_table
        let prop_sql="SELECT  "++mainkey++",\"主要道路\" , \"村社区\",\"居民点\",\"次要道路\",\"楼栋号\",\"单元号\",\"门牌1\",\"门牌2\" ,uid FROM \"" ++ T.unpack(prop_table) ++ "\"  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        vals <- quickQuery   prop_conn_action prop_sql []
        let stringRows = map convRow vals
        return stringRows
        --print "all right"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlroad,sqlvillage,sqljmd,sqlsecroad,sqlbuild,sqlcell,sqldoor1,sqldoor2,sqluid] =
                  [intid,road,village,jmd,secroad,build,cell,door1,door2,uid]
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
                        uid  =case fromSql sqluid of
                                   Just x -> x
                                   Nothing -> ""

          convRow x = fail $ "Unexpected result: " ++ show x






--获取已经分解的门牌数据并进行匹配

getOrcl_splitdoorplate prop_conn  prop_table  prop_limit mainkey =
    do
        --print "ooo"
        --print prop_table
        let prop_sql="SELECT  "++mainkey++",主要道路 , 村社区,居民点,次要道路,楼栋号,单元号,门牌1,门牌2,uid FROM " ++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn

        vals <- quickQuery   prop_conn_action prop_sql []
        let stringRows = map convRow vals
        return stringRows
        --print "all right"
    where convRow :: [SqlValue] -> [String]
          convRow [sqlId, sqlroad,sqlvillage,sqljmd,sqlsecroad,sqlbuild,sqlcell,sqldoor1,sqldoor2,sqluid] =
                  [intid,road,village,jmd,secroad,build,cell,door1,door2,uid]
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
                        uid  =case fromSql sqluid of
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
patternOrcl_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit mainkey time=
    do

        getOrclpatternControl (issplit!!0)  prop_conn prop_table prop_limit (mainkey!!0) time
        getOrclpatternControl (issplit!!1)  space_conn  space_table  space_limit (mainkey!!1) time

        space_conn_action <- space_conn
        prop_conn_action <- prop_conn

        doorplate_split <- getOrcl_splitdoorplate prop_conn  prop_table  prop_limit (mainkey!!0)

        let totalnum =length doorplate_split
        if(totalnum >0)then(initStatueValue time)else(print "nothing")

        print "get over"

        sequence [makePatternOrcl_Orcl rowdata space_conn_action space_limit space_table prop_conn_action prop_table mainkey time (fromIntegral totalnum ::Float) | rowdata <- doorplate_split]


        print "done"


--单个数据相似匹配
similarOrcl_Pg list prop_table prop_conn_action=do
    print "not done"



initStatueValue time=do
    statue <- readIORef patterStatuesVar
    let statu_arr=[if(a!!2==time)then([a!!0,a!!1,a!!2,a!!3, T.pack("0")])
                         else(a) | a<-statue]
    writeIORef patterStatuesVar statu_arr


splitStatue totalnum time table mystatue=do
    statue <- readIORef patterStatuesVar
    let statu_arr=[if(a!!2==time)then([table,a!!1,a!!2,T.pack(mystatue), T.pack( show (((read (T.unpack (a!!4)) )::Float) + (1/totalnum)))])
                     else(a) | a<-statue]
    writeIORef patterStatuesVar statu_arr
    --print "done"

--单个数据更新orcl
saveRowSplitOrcl  rowdata table conn_action time totalnum mainkey=do
    --print "save begin"
    let doorplate = snd (rowdata)
    testarr <- patternToList  doorplate
    let filter_list=patternFilter testarr  doorplate
    saveSplitDoorplate filter_list conn_action (T.unpack table) (fst rowdata) mainkey
    splitStatue  totalnum time table "分解数据"

--单个数据更新postgres
saveRowSplitPg  rowdata table conn_action time totalnum mainkey=do
    let doorplate = snd (rowdata)
    testarr <- patternToList  doorplate
    let filter_list=patternFilter testarr  doorplate
    saveSplitDoorplatePg filter_list conn_action (T.unpack table) (fst rowdata) mainkey

    --statue <- readIORef patterStatuesVar
    --let statu_arr=[if(a!!2==time)then([a!!0,a!!1,a!!2,T.pack("正在匹配"), T.pack( show (((read (T.unpack (a!!4)) )::Float) + (1/totalnum)))])
    --                 else(a) | a<-statue]
    --writeIORef patterStatuesVar statu_arr
    splitStatue  totalnum time table "分解数据"
    --print "done"




getPgpatternControl issplit pg_conn table limit mainkey time= do
    case issplit of "true"  -> do let sql="SELECT "++ mainkey ++" , doorplate FROM \""++ T.unpack(table) ++ "\"  " ++ T.unpack(limit)
                                  pg_conn_action <- pg_conn
                                  vals <- quickQuery pg_conn_action sql []
                                  let stringRows = map convRow vals
                                  --print  stringRows
                                  initStatueValue time
                                  let totalnum =length stringRows
                                  sequence [saveRowSplitPg  rowdata table pg_conn_action time (fromIntegral totalnum ::Float) mainkey| rowdata <- stringRows]
                                  print "split end"
                               where convRow :: [SqlValue] -> (Integer,String)
                                     convRow [sqlId, sqlDoorplate] =
                                             (rid,doorplate)
                                             where rid = (fromSql sqlId)::Integer
                                                   doorplate = case fromSql sqlDoorplate of
                                                            Just x -> x
                                                            Just "null" -> ""
                                                            Nothing -> ""





                    "false" -> do print "no split"
                                  statue <- readIORef patterStatuesVar
                                  let statu_arr=[if(a!!2==time)then([a!!0,a!!1,a!!2,T.pack("匹配完成"),T.pack("1")])
                                                 else(a) | a<-statue]
                                  writeIORef patterStatuesVar statu_arr



getOrclpatternControl issplit orcl_conn table limit mainkey time= do
    case issplit of "true"  -> do let sql="SELECT "++ mainkey ++" , doorplate FROM "++ T.unpack(table) ++ "  " ++ T.unpack(limit)
                                  orcl_conn_action <- orcl_conn
                                  vals <- quickQuery orcl_conn_action sql []
                                  let stringRows = map convRow vals
                                  --print  stringRows
                                  initStatueValue time
                                  let totalnum =length stringRows
                                  sequence [saveRowSplitOrcl  rowdata table orcl_conn_action time (fromIntegral totalnum ::Float) mainkey | rowdata <- stringRows]
                                  print "split end"
                               where convRow :: [SqlValue] -> (Integer,String)
                                     convRow [sqlId, sqlDoorplate] =
                                             (rid,doorplate)
                                             where rid = (fromSql sqlId)::Integer
                                                   doorplate = case fromSql sqlDoorplate of
                                                            Just x -> x
                                                            Just "null" -> ""
                                                            Nothing -> ""





                    "false" -> do print "no split"

--获取orcl主键
--getOrclkeyColumn conn_action table =do

--postgis向orcl查询分解数据并匹配
patternPg_Orcl prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit mainkey time=
    do

        getPgpatternControl (issplit!!0)  prop_conn prop_table prop_limit (mainkey !!0) time
        getOrclpatternControl (issplit!!1)  space_conn  space_table  space_limit (mainkey !!1) time

        space_conn_action <- space_conn
        prop_conn_action <- prop_conn

        doorplate_split <- getPg_splitdoorplate prop_conn  prop_table  prop_limit (mainkey !!0)
        let totalnum =length doorplate_split
        if(totalnum >0)then(initStatueValue time)else(print "nothing")


        sequence [makePatternOrcl rowdata space_conn_action space_limit space_table prop_conn_action prop_table mainkey time (fromIntegral totalnum ::Float)  | rowdata <- doorplate_split]


        print "done"



--orcl向postgis查询分解数据并匹配
patternOrcl_Pg prop_conn space_conn prop_table space_table prop_limit space_limit prop_type space_type issplit mainkey time=
    do
        let prop_sql="SELECT id , doorplate FROM "++ T.unpack(prop_table) ++ "  " ++ T.unpack(prop_limit)
        prop_conn_action <- prop_conn
        vals <- quickQuery prop_conn_action prop_sql []
        let stringRows = map convRow vals

        let totalnum =length stringRows

        sequence [saveRowSplitOrcl  rowdata prop_table prop_conn_action time (fromIntegral totalnum ::Float) mainkey| rowdata <- stringRows ]


        let space_sql="SELECT gid , doorplate FROM "++ T.unpack(space_table) ++ "  " ++ T.unpack(space_limit)
        space_conn_action <- space_conn
        space_vals <- quickQuery space_conn_action space_sql []
        let stringRows_space = map convRow space_vals
        let totalnum= length stringRows_space
        sequence [saveRowSplitPg  rowdata prop_table prop_conn_action time (fromIntegral totalnum ::Float) mainkey | rowdata <- stringRows_space ]


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
    let regex ="[0-9A-Z一二三四五六七八九十东南西北甲乙丙丁－.、,()；;-]+[号室]"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出主要道路
splitDoorplateMainRoad doorplate=do
    --let name ="台品街道纹二大道120号中天大厦一单元24甲室"::String
    --let regex=".+(路|大道|街|街道)"::String
    let regex="[^村街镇区]+(路|大道|街|街道)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出村社区
splitDoorplateVillage doorplate =do
    --let regex=".+(村|居|小区|花园|社区|苑|公寓|墩|堂村|堂|花城)"::String
    let regex="(村|新村|村村|居|小区|花园|社区|苑|公寓|墩|堂村|堂|花城)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出次要道路
splitDoorplateSecRoad doorplate =do
    --let regex=".+(弄|里|巷)"::String
    let regex="(弄|里|巷)"::String
    return ( doorplate =~ regex :: [MatchArray])

--分出单元号
splitDoorplateCell doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十－-]+单元" ::String
    return ( doorplate =~ regex :: [MatchArray])

--分出楼栋号
splitDoorplateBuild doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十－-]+(栋|幢|楼|号楼)" ::String
    return ( doorplate =~ regex :: [MatchArray])

--分出居民点
splitDoorplateJmd doorplate =do
    let regex="[0-9０-９A-Z一二三四五六七八九十-]+单元" ::String
    return ( doorplate =~ regex :: [MatchArray])



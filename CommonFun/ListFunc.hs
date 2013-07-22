module CommonFun.ListFunc
where

import Import

import Data.List
import Data.List.Split

slice :: Int -> Int -> [t] ->[t]
slice from to xs = take to (drop from xs)

replace old new =intercalate new . splitOn old


replaceList :: [String] ->String ->String ->String
replaceList [] new content=content
replaceList (x:xs) new content=replaceList xs new ((intercalate new . splitOn x ) content)




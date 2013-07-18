module CommonFun.ListFunc
where

import Import

slice :: Int -> Int -> [t] ->[t]
slice from to xs = take to (drop from xs)
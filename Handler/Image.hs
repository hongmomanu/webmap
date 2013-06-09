module Handler.Image where

import Import

getImageR :: Handler Html
-- getImageR = error "Not yet implemented: getImageR"
getImageR =do
   sendFile typeJpeg "/Users/jack/Pictures/平沙落雁/200811117508424_2.jpg"

module Scenes.Talk exposing (..)

import Data exposing (Data)
import Html exposing (..)
import TalkLayout
import Time


view : Time.Posix -> Data -> Html msg
view =
    TalkLayout.view
        { isGuest = False
        }

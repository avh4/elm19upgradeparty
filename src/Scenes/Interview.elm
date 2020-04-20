module Scenes.Interview exposing (view)

import Data exposing (Data)
import Html exposing (..)
import TalkLayout


view : Data -> Html msg
view =
    TalkLayout.view
        { isGuest = True
        }
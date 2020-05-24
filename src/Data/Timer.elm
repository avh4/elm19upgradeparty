module Data.Timer exposing (timer)

import Components.Timer as Timer
import Time


lastTime h m s ms =
    ((((h * 60) + m) * 60 + s) * 1000) + ms


timer =
    -- elm-animator project
    -- Just ( lastTime 3 34 20 0, Nothing )
    -- TDD project
    Just ( lastTime 14 14 24 0, Nothing )

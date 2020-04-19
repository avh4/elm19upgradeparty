module ScheduleLayout exposing (Config, view)

import Data exposing (Data)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Extra exposing (viewMaybe)


type alias Config =
    { fadeBottom : Bool
    , sceneTitle : Maybe String
    , scheduleTitle : String
    , highlightFirst : Bool
    }


view : Config -> Data -> Html msg
view config data =
    main_
        [ class "main-scene gradient"
        , attribute "role" "main"
        ]
        [ div
            [ class "positioned"
            , style "width" "320px"
            , style "height" "100%"
            ]
            [ div
                [ style "padding" "100px 40px 100px 20px"
                , style "font-size" "20px"
                ]
                [ text (Maybe.withDefault "" data.summary)
                , br [] []
                , br [] []
                , br [] []

                -- TODO: show data.links here instead?
                , text "Elm 0.19 upgrade guide: "
                , a [] [ text "https://is.gd/xakovu" ]
                ]
            , let
                viewCharity charity =
                    div
                        [ class "positioned"
                        , style "bottom" "0"
                        , style "height" "170px"
                        , style "font-size" "20px"
                        , style "padding" "10px"
                        ]
                        [ span [ class "dim" ] [ text "Today's charity: " ]
                        , text charity.name
                        , br [] []
                        , div
                            [ style "font-size" "80%"
                            , style "line-height" "1.1"
                            , style "padding" "5px"
                            ]
                            [ i [] [ text charity.description ]
                            ]
                        , span [ class "dim" ] [ text "Donate at " ]
                        , a [] [ text charity.donateLink ]
                        ]
              in
              viewMaybe viewCharity data.charity
            ]
        , div
            [ class <|
                if config.fadeBottom then
                    "positioned fade-bottom"

                else
                    "positioned"
            , style "left" "320px"
            ]
            [ h1
                [ class "project-name" ]
                [ text data.title ]
            , viewMaybe
                (\title -> h2 [] [ text title ])
                config.sceneTitle
            , h3 [] [ text config.scheduleTitle ]
            , let
                viewItem item =
                    li []
                        [ b [ class "schedule" ]
                            [ text (Maybe.withDefault "❧" item.time) ]
                        , text item.description
                        ]
              in
              ul
                [ class <|
                    if config.highlightFirst then
                        "large-schedule highlight-first"

                    else
                        "large-schedule"
                ]
              <|
                List.map viewItem data.schedule.upcoming
            , br [] []
            ]
        ]

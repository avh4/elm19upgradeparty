module ScreenShareLayout exposing (Config, view)

import Components.Timer as Timer
import Data exposing (Data)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html, a, br, main_)
import Html.Attributes exposing (attribute, class, id)
import Palette
import Time


type alias Config =
    { showTopCam : Bool
    , showBottomCam : Bool
    }


view : Config -> Time.Posix -> Data -> Html msg
view config now data =
    let
        totalHeight =
            720

        screenWidth =
            900

        topCamHeight =
            if config.showTopCam then
                240

            else
                0

        bottomCamHeight =
            if config.showBottomCam then
                220

            else
                0

        charityHeight =
            if
                (totalHeight - (topCamHeight + bottomCamHeight) > 400)
                    && (data.charity /= Nothing)
            then
                120

            else
                0

        infoHeight =
            totalHeight
                - (topCamHeight + bottomCamHeight + charityHeight)

        tightLayout =
            infoHeight < 300
    in
    main_
        [ class "main-scene"
        , attribute "role" "main"
        ]
        [ row
            [ height (px totalHeight)
            , width fill
            ]
            [ el
                [ width (px screenWidth)
                , height fill
                , htmlAttribute (id "screen")
                , htmlAttribute (class "placeholder")
                ]
                none
            , column
                [ height fill
                , width fill
                , paddingEach { bottom = 10, top = 0, left = 0, right = 0 }
                , spacing 18
                , htmlAttribute (class "gradient")
                ]
              <|
                List.filterMap identity
                    [ if topCamHeight > 0 then
                        el
                            [ width fill
                            , height (px topCamHeight)
                            , htmlAttribute (id "cam")
                            , htmlAttribute (class "placeholder")
                            ]
                            none
                            |> Just

                      else
                        Nothing
                    , paragraph
                        [ Font.size 24
                        , Font.center
                        , Font.bold
                        , spacing 5
                        , paddingXY 20 0
                        ]
                        [ text data.title ]
                        |> Just
                    , Maybe.map
                        (\summary ->
                            paragraph
                                [ paddingXY 20 0
                                , Font.size <|
                                    if tightLayout then
                                        18

                                    else
                                        21
                                ]
                                [ text summary ]
                        )
                        data.summary
                    , viewGoals now data.goals
                    , Just <| viewSchedule data.schedule
                    , Maybe.map (el [ alignBottom, width fill ] << Timer.view now) data.timer
                    , let
                        viewCharity info =
                            paragraph
                                [ Font.size 20
                                , paddingXY 20 0
                                , alignBottom
                                ]
                                [ el
                                    [ htmlAttribute (class "dim") ]
                                    (text "Today's charity: ")
                                , text info.name
                                , html <| br [] []
                                , el
                                    [ htmlAttribute (class "dim") ]
                                    (text "Donate at ")
                                , html <| a [] [ Html.text info.donateLink ]
                                ]
                      in
                      if charityHeight > 0 then
                        Maybe.map viewCharity data.charity

                      else
                        Nothing
                    , if bottomCamHeight > 0 then
                        el
                            [ width fill
                            , height (px bottomCamHeight)
                            , htmlAttribute (id "cam2")
                            , htmlAttribute (class "placeholder")
                            ]
                            none
                            |> Just

                      else
                        Nothing
                    ]
            ]
            |> layout [ Font.color Palette.color.mainText ]
        ]


viewGoals : Time.Posix -> List ( String, Time.Posix ) -> Maybe (Element msg)
viewGoals now goals =
    if goals == [] then
        Nothing

    else
        let
            viewGoal ( goal, start ) =
                row [ width fill, spacing 3 ]
                    [ el
                        [ alignTop
                        , moveDown 3
                        ]
                        (text "☞ ")
                    , paragraph
                        [ spacing 2
                        ]
                        [ text goal
                        , el
                            [ alignRight
                            , alpha 0.7
                            , moveDown 0.5
                            ]
                            (text <| Timer.stringMS now ( 0, start ))
                        ]
                    ]
        in
        Just <|
            column
                [ width fill
                , paddingXY 20 0
                , spacing 2
                ]
                (List.map viewGoal goals)


viewSchedule : Data.Schedule -> Element msg
viewSchedule schedule =
    let
        viewScheduleItem i item =
            row [ spacing 10 ]
                [ if i == 0 then
                    el
                        [ Background.color Palette.color.accent
                        , width (px 4)
                        , height fill
                        ]
                        none

                  else
                    el [ alignTop, width (px 4) ] (text "•")
                , paragraph
                    [ spacing 2
                    , Font.color <|
                        if i == 0 then
                            Palette.color.accent

                        else
                            Palette.color.mainText
                    ]
                    [ Maybe.map (\time -> text (time ++ ": ")) item.time
                        |> Maybe.withDefault none
                    , text item.description
                    ]
                ]
    in
    column
        [ width fill
        , height fill
        , scrollbarY
        , paddingXY 20 0
        , htmlAttribute (class "fade-bottom")
        ]
        [ el
            [ Font.size 24
            , height (px 36)
            , Font.bold
            ]
            (text "Schedule")
        , column
            [ Font.size 18
            , spacing 10
            ]
          <|
            List.indexedMap viewScheduleItem schedule.upcoming
        ]

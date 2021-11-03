module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Exercises as Exercises exposing (Section(..))
import Html exposing (Html, a, button, div, h1, h2, hr, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Markdown
import SharedType exposing (CustomContent, CustomSlide, Message(..), Model)
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)
import Time exposing (Posix)


type alias Message =
    SharedType.Message


type alias Model =
    SharedType.Model


{-| Update function for the custom content
-}
update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        Tick _ ->
            ( { model | displayTime = model.displayTime - 1000 }, Cmd.none )

        AddStartMinute ->
            ( { model | startTime = model.startTime + 60 }, Cmd.none )

        StartStopPressed state ->
            ( { model
                | displayTime = model.startTime * 1000
                , timerStarted = not state
              }
            , Cmd.none
            )


{-| View function for the custom content that shows time remaining
-}
view : Model -> Html Message
view model =
    div
        [ class "stopwatch" ]
        [ span []
            [ if
                model.startTime
                    /= 0
                    && model.timerStarted
              then
                if model.displayTime > 0 then
                    text
                        ((round model.displayTime // 1000 |> String.fromInt)
                            ++ " seconds"
                        )

                else
                    text "Time's up"

              else
                button
                    [ onClick AddStartMinute ]
                    [ text (String.fromFloat model.startTime) ]
            ]
        , button [ onClick (StartStopPressed model.timerStarted) ]
            [ if model.timerStarted then
                text ""

              else
                text "Go !"
            ]
        ]


{-| Inputs for the custom content
-}
subscriptions : Model -> Sub Message
subscriptions model =
    if model.timerStarted then
        Time.every 1000 Tick

    else
        Sub.none


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ SessionStart
        { facilitatedBy = "Rupert, Dan, Felienne, Katja and Nick"
        , miroLink = "https://miro.com/welcomeonboard/YlpYNm5TdUViMzAybWY4b1l3c3o2bk5TRWk4Y0xiOG9uajFWcFp4cFFCNlh1dUZVUmJadmhqekxOTGhVc3JLOHwzMDc0NDU3MzQ5MTgyMDYwNDgy?invite_link_id=629576332995"
        , annotationLink = "https://annotate.code-reading.org/#/file/M4FwhgTsAWCWAOB6UkYMQIwDYHsOIGMCAWARgHZziAmDDAMwFNSBOAZkcZfoIAYATauQAcxRsX7kAbAFZhperN61kEAogC2OfgFcsjYIkYQsYAHYBzAHRQgA"
        , pdfLink = "https://katj.am/code.pdf"
        }
    , RandomLine
    , SecondThoughts
    , RecapStructure
        { annotationLink = "https://annotate.code-reading.org/#/file/M4FwhgTsAWCWAOB6UkYMQIwDYHsOIGMCAWARgHZziAmDDAMwFNSBOAZkcZfoIAYATauQAcxRsX7kAbAFZhperN61kEAogC2OfgFcsjYIkYQsYAHYBzAHRQgA"
        , pdfLink = "https://katj.am/code.pdf"
        }
    , DecisionsMade
    , DecisionsConsequences
    , DecisionsWhy
    , Feedback
    , SessionEnd
        { codeDescription = "Code from Starship - starship.rs Cross-shell prompt"
        , codeLink = "https://github.com/starship/starship/blob/cc417742bbfe193ee9fc0d2784e4d76581f6502b/src/modules/erlang.rs"
        }
    ]
        |> List.map (\section -> Exercises.slideContent section)
        |> List.concat
        |> List.map Exercises.paddedSlide

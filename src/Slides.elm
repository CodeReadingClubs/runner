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


annotationLink : String
annotationLink =
    "https://annotate.code-reading.org/#/file/LYewXglgNlCGD0BzApgYwNYgLQBNkDd4AjKEI+HARgAYB2I1ADlmVh1ScoDYjZGBWVEQBMlVJVhdYE2OJwAWZADMAnEuIAnEAHcAzsg3xQOAK5Rku+ABEIu1CHwGAngDoAVruBA"


miroLink : String
miroLink =
    "https://miro.com/welcomeonboard/dlVRdlJVSk5EVlFBazdBV0hUdHc1aVZ6SDJVVHlhTEdZcGhQdERIUXF5WHhJa29FQUhWMHdnNHk2RXhscHBKZnwzMDc0NDU3MzQ5MTgyMDYwNDgy?invite_link_id=406316329300"


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ SessionStartFirstClub
        { facilitatedBy = "Katja"
        , miroLink = miroLink
        , annotationLink = annotationLink
        , pdfLink = ""
        }
    , FirstGlance
    , SecondThoughts
    , AnnotateStructure { annotationLink = annotationLink, pdfLink = "" }
    , ImportantLines
    , Summarise
    , SessionEnd
        { codeDescription = "Firefox browser module Discovery.jsm"
        , codeLink = "https://github.com/mozilla/gecko-dev/blob/d107bc8aeadcc816ba85cb21c1a6a1aac1d4ef9f/browser/modules/Discovery.jsm"
        }
    ]
        |> List.map (\section -> Exercises.slideContent section)
        |> List.concat
        |> List.map Exercises.paddedSlide

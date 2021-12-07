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
    "https://annotate.code-reading.org/#/file/A4UwdsD2AuD0oRrARgG0slIBm2DM2IAHACwEDGADHgIYCMBeRyIATASea+QOwgu5WANgAmyGihrkA1uBGwAzgCdysGsGCwlwVQEcAriCUBLEAtgA3UwHcjAOnKoAVkA"


miroLink : String
miroLink =
    "https://miro.com/welcomeonboard/ekZnZ2RzUzBRNkpIZTFzMHJsM1VSY3ZrRnNteHBnVTBvMkMwUnhseWJwOWRFVEc1QVhGWWVLT2x4djdVaHZMTXwzMDc0NDU3MzQ5MTgyMDYwNDgy?invite_link_id=511929949465"


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ SessionStartFirstClub
        { facilitatedBy = "Code Reading Club team (Dan, Felienne, Katja, Nick & Rupert)"
        , miroLink = miroLink
        , annotationLink = annotationLink
        , pdfLink = ""
        }
    , FirstGlance
    , SecondThoughts
    , Syntax
    , AnnotateStructure
        { annotationLink = annotationLink
        , pdfLink = ""
        }
    , ImportantLines
    , Summarise
    , Feedback
    , SessionEnd
        { codeDescription = "penpot: viewer.clj"
        , codeLink = "https://github.com/penpot/penpot/blob/beff3fe843fc03a13f38be23f4c2c7ebeff26dba/backend/src/app/rpc/queries/viewer.clj"
        }
    ]
        |> List.map (\section -> Exercises.slideContent section)
        |> List.concat
        |> List.map Exercises.paddedSlide

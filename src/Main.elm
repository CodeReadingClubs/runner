module Main exposing (main)

import Base exposing (Base)
import Browser
import Html exposing (..)
import Html.Events exposing (..)


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }


type alias Model =
    { base : Base
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { base =
            Base.init
      }
    , Cmd.none
    )


type Msg
    = DoAction


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoAction ->
            ( { model | base = { value = model.base.value + 1 } }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Kelm App", body = [ view model ] }


view : Model -> Html Msg
view model =
    div
        []
        [ text "Base template "
        , Html.button
            [ Html.Events.onClick DoAction
            ]
            [ text "Do action!" ]
        , Base.view model.base
        ]

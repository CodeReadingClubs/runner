module Base exposing (Base, init, view)

import Html exposing (..)


type alias Base =
    { value : Int
    }


init : Base
init =
    { value = 0
    }


view : Base -> Html msg
view base =
    Html.div []
        [ text ("Value is " ++ String.fromInt base.value)
        ]

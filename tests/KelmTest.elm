module KelmTest exposing (suite)

import Base
import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "BaseStart"
        [ test "initial state" <|
            \() ->
                Base.init
                    |> Expect.equal
                        { value = 0
                        }
        ]

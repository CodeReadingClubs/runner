module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html, a, div, h1, h2, img, li, p, small, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Markdown
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)


{-| Model type of the custom content
-}
type alias Model =
    Float


{-| Message type for the custom content
-}
type alias Message =
    Float


{-| Type for custom content
-}
type alias CustomContent =
    Content Model Message


{-| Type for custom slide
-}
type alias CustomSlide =
    Slide Model Message


{-| Update function for the custom content
-}
update : Message -> Model -> ( Model, Cmd Message )
update elapsed time =
    ( time + elapsed, Cmd.none )


{-| View function for the custom content that shows elapsed time for the slide
-}
view : Model -> Html Message
view time =
    small
        [ style "position" "absolute", style "bottom" "0", style "right" "0" ]
        [ text
            ("the slide is visible for "
                ++ (round time // 1000 |> String.fromInt)
                ++ " seconds"
            )
        ]


{-| Inputs for the custom content
-}
subscriptions : Model -> Sub Message
subscriptions _ =
    onAnimationFrameDelta identity


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ [ slideHeading "Introduction"
      , item (p [] [ text "Katja Mordaunt @katjam on Github" ])
      , bullets
            [ bulletLink "Slides for this talk: runner.code-reading.org" "https://runner.code-reading.org"
            , bulletLink "Jamboard for workshop exercises" "https://jamboard.google.com/d/1t0IUpVMyk-e_E1h55gxnuFqQ0MRuuXbSPLb1wBgnTPE/viewer"
            ]
      ]
    , [ slideHeading "How this will work"
      , bullets
            [ bullet "Grab a copy of code from googledocs"
            , bullet "I'll keep the exercises & timer posted on my screen"
            , bullet "You write on your code doc & the jamboard"
            ]
      ]
    , [ slideHeading "Why are we doing this?"
      , slideP "Take a few minutes to talk about your motivation for doing the club. This is important because it will help you support each other and make it more likely that your group will feel that the club sessions have value for them."
      , timedHeading "2" "Independently" "Note down one thing about the club" |> hide
      , bullets [ bullet "that you are looking forward to or excited about", bullet "that you are worried or confused about" ] |> hide
      , timedHeading "5" "Together" "Discuss" |> hide
      , bullets
            [ bullet "Give everyone a chance to read out their hopes and fears"
            , bullet "Use the remaining time to discuss collectively what you want to get out of the club"
            , bullet "Decide how long you want your sessions to be and how often you want to run them"
            , bullet "Decide if the same person will facilitate all of the sessions or if you want to take turns"
            , bullet "Think about how to accommodate members of your group who might have varying levels of experience and confidence"
            ]
            |> hide
      ]
    , [ slideHeading "First glance"
      , slideP "The goal of this exercise is to practice to get a first impression of code and to act upon that. We all have different instincts and strategies for where to start when faced with a new piece of code. It doesn't matter how trivial you think the first and second things you noticed are."
      , timedHeading "1" "Independently" "Glance at the code"
      , slideP "It's important that is an immediate reaction."
      , bullets
            [ bullet "Right away, note down the first thing that catches your eye\n"
            , bullet "Then note down the second thing that catches your eye\n"
            , bullet "Take the remainder of the minute to think about why you noticed those things first"
            ]
      ]
    , [ slideHeading "First glance"
      , slideP "The goal of this exercise is to practice to get a first impression of code and to act upon that. We all have different instincts and strategies for where to start when faced with a new piece of code. It doesn't matter how trivial you think the first and second things you noticed are."
      , timedHeading "5" "Together" "Discuss"
      , slideP "Talk about why things might have jumped out for different people. It might be tempting for some people to start talking about the big picture; try to steer discussion back to individual details, rather than summaries.\n"
      , bullets
            [ bullet "How do those initial observations help with deciding what to look at next?"
            , bullet "What lines or facts or concepts were chosen by everyone versus by only a few people?"
            ]
      , slideP "Reflect also on what kind of knowledge you used in this exercise."
      , bullets
            [ bullet "Knowledge of the domain, of the programming language? Of a framework?"
            , bullet "What knowledge do you think might be needed to better understand this code?"
            ]
      ]
    , [ slideHeading "Questions?"
      , item (p [] [ text "elm package install w0rm/elm-slice-show" ])
      ]
    ]
        |> List.map paddedSlide


slideHeading : String -> CustomContent
slideHeading title =
    item (h1 [] [ text title ])


slideP : String -> CustomContent
slideP paragraph =
    item (p [] [ text paragraph ])


timedHeading : String -> String -> String -> CustomContent
timedHeading minutes who heading =
    container (h2 [])
        [ item (span [ class "time" ] [ text (minutes ++ "mins") ])
        , item (span [ class "who" ] [ text who ])
        , item (text heading)
        ]


bullets : List CustomContent -> CustomContent
bullets =
    container (ul [])


bullet : String -> CustomContent
bullet str =
    item (li [] [ text str ])


bulletLink : String -> String -> CustomContent
bulletLink str url =
    item (li [] [ a [ href url ] [ text str ] ])


{-| Custom slide that sets the padding and appends the custom content
-}
paddedSlide : List CustomContent -> CustomSlide
paddedSlide content =
    slide
        [ container
            (div [ class "slides", style "padding" "50px 100px" ])
            (content ++ [ custom 0 ])
        ]

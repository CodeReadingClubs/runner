module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Html exposing (Html, a, button, div, h1, h2, hr, li, p, span, text, ul)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Markdown
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)
import Time exposing (Posix)


{-| Model type of the custom content
-}
type alias Model =
    { displayTime : Float
    , startTime : Float
    , timerStarted : Bool
    }


{-| Message type for the custom content
-}
type Message
    = Tick Posix
    | AddStartMinute
    | StartStopPressed Bool


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
    [ [ slideHeading "Code Reading Club workshop"
      , item (h2 [] [ text "Katja Mordaunt" ])
      , slideP "email: katjamordaunt@gmail.com"
      , slideP "github: @katjam"
      , slideP "website: https://code-reading.org"
      , slideHr
      , bullets
            [ bulletLink "Slides for this talk: runner.code-reading.org" "https://runner.code-reading.org"
            , bulletLink "Jamboard (A-L) for workshop exercises" "https://jamboard.google.com/d/1t0IUpVMyk-e_E1h55gxnuFqQ0MRuuXbSPLb1wBgnTPE/edit"
            , bulletLink "Jamboard (M-Z) for workshop exercises" "https://jamboard.google.com/d/1rHKt3dEVQzN8mGuAEuPlmcN-EitMUEDecLBHuQ7w-S4/edit"
            , bulletLink "pdf annotation tool: goodannotations.com" "https://www.goodannotations.com/"
            , bulletLink "Code googledoc (view only)" "https://docs.google.com/document/d/1HEg5qMUYPS4FZd2EmaCVgoMeAcMbD_rUqiyln7Gs35k"
            , bulletLink "Clean pdf to download" "https://github.com/katjam/code-reading-runner/raw/main/src/assets/code.pdf"
            ]
      ]
    , [ slideHeading "How this will work?"
      , bullets
            [ bullet "Grab a copy of code"
            , bullet "I'll keep the exercises & timer posted on my screen"
            , bullet "You write on your code doc & the jamboard"
            ]
      , item (h2 [] [ text "Any questions before we start?" ]) |> hide
      ]
    , [ slideHeading "Why are we doing this?"
      , slideP "Take a few minutes to talk about your motivation for doing the club. This is important because it will help you support each other and make it more likely that your group will feel that the club sessions have value for them."
      , container (div [])
            [ timedHeading "1" "Independently" "Note down one thing"
            , bullets [ bullet "that you are looking forward to or excited about", bullet "that you are worried or confused about" ]
            ]
            |> hide
      ]
    , [ slideHeading "Why are we doing this?"
      , container (div [])
            [ timedHeading "3" "Together" "Discuss"
            , bullets
                [ bullet "Give everyone a chance to read out their hopes and fears"
                , bullet "Discuss collectively what you want to get out of the club"
                , bullet "Decide how long and how often you want your sessions to be"
                , bullet "Decide if the same person will always facilitate or if you want to take turns"
                , bullet "Think about how to accommodate members of your group who might have varying levels of experience and confidence"
                ]
            ]
      ]
    , [ slideHeading "First glance"
      , slideP "The goal of this exercise is to practice to get a first impression of code and to act upon that. We all have different instincts and strategies for where to start when faced with a new piece of code. It doesn't matter how trivial you think the first and second things you noticed are."
      , timedHeading "1" "Independently" "Glance at the code"
      , slideP "It's important that is an immediate reaction."
      , bullets
            [ bullet "Look at code for a few seconds. Note down the first thing that catches your eye"
            , bullet "Then look again for a few more seconds. Note down the second thing that catches your eye"
            , bullet "Now think about why you noticed those things first"
            ]
            |> hide
      ]
    , [ slideHeading "First glance"
      , timedHeading "4" "Together" "Discuss"
      , slideP "Talk about why things might have jumped out for different people. It might be tempting for some people to start talking about the big picture; try to steer discussion back to individual details, rather than summaries."
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
    , [ slideHeading "Code structure"
      , slideP "The goal of this exercise is to be a concrete thing to *do* when looking at new code for the first time. New code can be scary, doing something will help! Digital annotation can take a bit longer than on paper. Leave time for your group members to settle on a technique that works for them."
      , timedHeading "5" "Independently" "Examine structure"
      , slideP "Circle the places where they are defined a draw links to where they are used. Use 3 different colours."
      , bullets
            [ bulletLink "Clean pdf demo on goodannotations.com" "https://www.goodannotations.com/project/9QLhBgPoF5SK2UBm1J3arBakBz32/KSGpW01QDe"
            ]
      , bullets
            [ bullet "Variables"
            , bullet "Functions / Methods"
            , bullet "Instantiation"
            ]
            |> hide
      ]
    , [ slideHeading "Code structure"
      , timedHeading "6" "Together" "Discuss"
      , bullets
            [ bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
            , bullet "What patterns are visible from the colors and links only?"
            , bullet "How does the data flow through the code?"
            , bullet "What parts of the code seem to warrant more attention?"
            ]
      , bullets
            [ bulletLink "Coloured pdf demo on goodannotations.com" "https://www.goodannotations.com/project/9QLhBgPoF5SK2UBm1J3arBakBz32/tGBSC1xrUR"
            , bulletLink "Coloured pdf to download" "https://github.com/katjam/code-reading-runner/raw/main/src/assets/code-coloured.pdf"
            ]
      ]
    , [ slideHeading "Content"
      , slideP "The goal of this exercise is to start to think about which lines in the code define its essence, have the biggest impact or need to be paid close attention to."
      , timedHeading "4" "Independently" "Identify important lines"
      , slideP "Briefly discuss what it means to be important as a group (if you want to)"
      , bullets
            [ bullet "then, identify the 4 lines you consider most important"
            ]
      ]
    , [ slideHeading "Content"
      , timedHeading "6" "Together" "Discuss"
      , slideP "Discuss in the group:"
      , bullets
            [ bullet "lines covered by many people?"
            , bullet "lines named but not by a lot of people"
            , bullet "Agree less than 8 of the most important lines"
            ]
      , slideP "Take turns in the group, and let every member talk about the code for 30 seconds (could also be one sentence each). Try to add new information and not repeat things that have been said, and repeat until people do not know new things anymore."
      , slidePMarkdown "[Save the last word for me protocol](https://lead.nwp.org/knowledgebase/save-the-last-word-for-me-protocol/)"
      ]
    , [ slideHeading "Summary"
      , timedHeading "3" "Independently" "Summarize"
      , slideP "Try to write down the essence of the code in a few sentences."
      , container (div [])
            [ timedHeading "4" "Together" "Discuss"
            , bullets
                [ bullet "topics covered by many vs few"
                , bullet "strategies used to create the summary (e.g. method names, documentation, variable names, prior knowledge of system)"
                ]
            ]
            |> hide
      ]
    , [ slideHeading "Reflect on the session"
      , slideP "If you have time, it's helpful to wrap up the session with a little reflection."
      , timedHeading "5" "Together" "Note down things"
      , bullets
            [ bullet "that went well or felt good"
            , bullet "you want to try to do differently next time because they didn't work or felt bad"
            ]
      ]
    , [ slideHeading "What now?"
      , slideP "Code reading club resources: https://code-reading.org"
      , slideP "Read Felienne's book! The Programmer's Brain"
      , slideP "Start a club"
      , slideP "Join a club"
      , slideP "Get in touch katjamordaunt@gmail.com"
      ]
    ]
        |> List.map paddedSlide


slideHeading : String -> CustomContent
slideHeading title =
    item (h1 [] [ text title ])


slideHr : CustomContent
slideHr =
    item (hr [] [])


slideP : String -> CustomContent
slideP paragraph =
    item (p [] [ text paragraph ])


slidePMarkdown : String -> CustomContent
slidePMarkdown paragraph =
    item (Markdown.toHtml [] paragraph)


timedHeading : String -> String -> String -> CustomContent
timedHeading minutes who heading =
    let
        label =
            if minutes == "1" then
                " minute"

            else
                " minutes"
    in
    container (h2 [])
        [ item (text heading)
        , item (span [ class "who" ] [ text who ])
        , item (span [ class "time" ] [ text (minutes ++ label) ])
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
            (content
                ++ [ custom
                        { displayTime = 0
                        , startTime = 0
                        , timerStarted = False
                        }
                   , item
                        (div [ class "footer" ]
                            [ text "Slides for this workshop: https://runner.code-reading.org"
                            ]
                        )
                   ]
            )
        ]

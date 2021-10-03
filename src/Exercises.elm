module Exercises exposing (..)

import Html exposing (Html, a, button, div, h1, h2, hr, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Markdown
import SharedType exposing (CustomContent, CustomSlide, EndInfo, StartInfo)
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)
import Time exposing (Posix)


type
    Section
    -- Information
    = SessionStart StartInfo
    | WhyDoingThis
    | SessionEnd EndInfo
      -- First Look
    | FirstGlance
    | AnnotateStructure
    | ListNames
    | RandomLine
    | ImportantLines
    | Summarise
      -- Second Look
    | RecapStructure
    | CentralThemes
    | CentralConcepts
    | DecisionsMade
    | DecisionsConsequences
    | DecisionsWhy


slideContent : Section -> List ( Bool, List SharedType.CustomContent )
slideContent section =
    case section of
        SessionStart { facilitatedBy, miroLink, annotationLink, pdfLink } ->
            [ ( False
              , [ slideHeading "Code Reading Club"
                , slideP ("Facilitators: " ++ facilitatedBy)
                , slideP "hello@code-reading.org | https://code-reading.org"
                , slideHr
                , bullets
                    [ bulletLink "Code of conduct" "https://code-reading.org/conduct"
                    , bulletLink "Miro board" miroLink
                    , bulletLink "Code in annotation tool" annotationLink
                    , bulletLink "Code pdf to download" pdfLink
                    ]
                , slideHr
                , bullets
                    [ bullet "Grab a copy of the code"
                    , bullet "I'll keep the exercises & timer posted on my screenshare"
                    , bullet "Join the miro and claim a board"
                    , bullet "Make independent notes on your board"
                    , bullet "After each exercise we'll copy any thoughts we want to share to a shared board"
                    ]
                , item (h2 [] [ text "Any questions before we start?" ]) |> hide
                ]
              )
            ]

        WhyDoingThis ->
            [ ( True
              , [ slideHeading "Why are we doing this?"
                , slideP "Take a few minutes to talk about your motivation for doing the club. This is important because it will help you support each other and make it more likely that your group will feel that the club sessions have value for them."
                , container (div [])
                    [ timedHeading "2" "Independently" "Note down one thing"
                    , bullets [ bullet "that you are looking forward to or excited about", bullet "that you are worried or confused about" ]
                    , item (img [ src "example-excited-worried.png", style "height" "250px" ] [])
                    ]
                    |> hide
                ]
              )
            , ( True
              , [ slideHeading "Why are we doing this?"
                , container (div [])
                    [ timedHeading "5" "Together" "Discuss"
                    , bullets
                        [ bullet "Give everyone a chance to read out their hopes and fears"
                        , bullet "Discuss what you want to get out of the club"
                        , bullet "Think about how to accommodate members with varying levels of experience and confidence"
                        ]
                    ]
                ]
              )
            ]

        SessionEnd { codeDescription, codeLink } ->
            [ ( False
              , [ slideHeading "What now?"
                , slideP "Code used for this session..."
                , bullets
                    [ bulletLink codeDescription codeLink
                    ]
                , slideP "Code reading club resources: https://code-reading.org"
                , slideP "Read Felienne's book! The Programmer's Brain"
                , slideP "Start a club"
                , slideP "Join a club"
                , slideP "Get in touch hello@code-reading.org"
                ]
              )
            ]

        -- First Look
        FirstGlance ->
            [ ( True
              , [ slideHeading "First glance"
                , slideP "The goal of this exercise is to practice to get a first impression of code and act upon that. We all have different instincts and strategies for where to start when faced with a new piece of code. It doesn't matter how trivial you think the first and second things you noticed are."
                , timedHeading "1" "Independently" "Glance at the code"
                , slideP "It's important that is an immediate reaction."
                , bullets
                    [ bullet "Look at code for a few seconds. Note the first thing that catches your eye"
                    , bullet "Then look again for a few more seconds. Note the second thing that catches your eye"
                    , bullet "Now think about why you noticed those things first & note that down"
                    ]
                , item (img [ src "example-first-glance.png", style "width" "120%", style "margin" "-10px 0 0 -10%" ] [])
                ]
              )
            , ( True
              , [ slideHeading "First glance"
                , timedHeading "8" "Together" "Discuss"
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
              )
            ]

        AnnotateStructure ->
            [ ( True, [] ) ]

        ListNames ->
            [ ( True, [] ) ]

        RandomLine ->
            [ ( True, [] ) ]

        ImportantLines ->
            [ ( True, [] ) ]

        Summarise ->
            [ ( True, [] ) ]

        -- Second Look
        RecapStructure ->
            [ ( True, [] ) ]

        CentralThemes ->
            [ ( True, [] ) ]

        CentralConcepts ->
            [ ( True, [] ) ]

        DecisionsMade ->
            [ ( True, [] ) ]

        DecisionsConsequences ->
            [ ( True, [] ) ]

        DecisionsWhy ->
            [ ( True, [] ) ]


{-| The list of slides
-}
slides : List (List SharedType.CustomContent)
slides =
    [ [ slideHeading "Code structure"
      , slideP "The goal of this exercise is to be a concrete thing to *do* when looking at new code for the first time. New code can be scary, doing something will help!"
      , timedHeading "8" "Independently" "Examine structure"
      , slideP "Highlight the places where they are defined a draw links to where they are used. Use 3 different colours."
      , bullets
            [ bulletLink "Code to annotate" "https://crc-annotations.netlify.app/#/file/IYBxCcHsDdgGwM4HoCCYqzgFQKYIC4IB0AUsLEgEZySVIDGAbPQJwDMAjACaNf0AM-FgCYA7Dn71h9LlwAsAVnH8AHFw4rhbYcAULgfJKAgx4+PISQJw9JAFtgASwB2SAFblgSSOADmR9FM4cwJkekg7ShdgfEdIZ2QAYQio5xi4hIAJHDgQHHAiD1ggA"
            ]
      , bullets
            [ bullet "Variables"
            , bullet "Functions / Methods"
            , bullet "Instantiation"
            ]
            |> hide
      ]
    , [ slideHeading "Code structure"
      , timedHeading "5" "Together" "Discuss"
      , bullets
            [ bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
            , bullet "What patterns are visible from the colors and links only?"
            , bullet "How does the data flow through the code?"
            , bullet "What parts of the code seem to warrant more attention?"
            ]
      ]
    , [ slideHeading "Content"
      , timedHeading "5" "Independently" "Identify important lines"
      , slideP "Briefly discuss what it means to be important as a group (if you want to)"
      , bullets
            [ bullet "then, identify the 4 lines you consider most important"
            ]
      ]
    , [ slideHeading "Content"
      , timedHeading "8" "Together" "Discuss"
      , slideP "Discuss in the group:"
      , bullets
            [ bullet "lines covered by many people?"
            , bullet "lines named but not by a lot of people"
            , bullet "Agree less than 8 of the most important lines"
            ]
      , slideP "Take turns in the group, and let every member talk about the code for 30 seconds (could also be one sentence each). Try to add new information and not repeat things that have been said, and repeat until people do not know new things anymore."
      ]
    , [ slideHeading "Reflect on the session"
      , slideP "If you have time, it's helpful to wrap up the session with a little reflection."
      , timedHeading "5" "Together" "Note down things"
      , bullets
            [ bullet "that went well or felt good"
            , bullet "you want to try to do differently next time because they didn't work or felt bad"
            ]
      ]
    ]


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
paddedSlide : ( Bool, List CustomContent ) -> CustomSlide
paddedSlide ( showStopwatch, content ) =
    slide
        [ container
            (div [ class "slides", style "padding" "50px 100px" ])
            (content
                ++ [ if showStopwatch then
                        custom
                            { displayTime = 0
                            , startTime = 0
                            , timerStarted = False
                            }

                     else
                        item (img [ src "icon.png", class "stopwatch" ] [])
                   , item
                        (div [ class "footer" ]
                            [ text "Slides for this workshop: https://runner.code-reading.org"
                            ]
                        )
                   ]
            )
        ]

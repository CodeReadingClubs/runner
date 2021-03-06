module Exercises exposing (..)

import Html exposing (Html, a, button, div, h1, h2, hr, img, li, p, span, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Markdown
import SharedType exposing (AnnotateInfo, CustomContent, CustomSlide, EndInfo, StartInfo)
import SliceShow.Content exposing (..)
import SliceShow.Slide exposing (..)
import Time exposing (Posix)


{-| The defined slides.
Use these to build your deck in Slides.elm
-}
type
    Section
    ----
    -- Club guidelines & group reflection
    ----
    = SessionStartFirstClub StartInfo
    | SessionStart StartInfo
    | WhyDoingThis
    | SecondThoughts
    | Reflect
    | Feedback
    | SessionEnd EndInfo
      ----
      -- First Look at a piece of code
      ----
    | FirstGlance
    | Syntax
    | AnnotateStructure AnnotateInfo
    | ListNames
    | RandomLine
    | ImportantLines
    | Summarise
      ----
      -- Second Look at the same code
      ----
    | RecapStructure (List Int)
    | CentralThemes
    | CentralConcepts
    | DecisionsMade
    | DecisionsConsequences
    | DecisionsWhy


slideContent : Section -> List ( Bool, List SharedType.CustomContent )
slideContent section =
    case section of
        SessionStartFirstClub { facilitatedBy, groupWorkspaceLink, annotationLink, pdfLink } ->
            [ ( False
              , [ slideHeading "Code Reading Club"
                , slideP ("Facilitators: " ++ facilitatedBy)
                , slideP "hello@codereading.club | https://codereading.club"
                , slideHr
                , bullets
                    [ bulletLink "Code of conduct" "https://codereading.club/conduct"
                    , bulletLink "Group workspace" groupWorkspaceLink
                    , bulletLink "Code in annotation tool" annotationLink
                    , if String.length pdfLink > 0 then
                        bulletLink "Code pdf to download" pdfLink

                      else
                        item (text "")
                    ]
                , slideHr
                , bullets
                    [ bullet "Hello! What is code reading? Why are we all here? How does it work? Intro Tools."
                    , bullet "Don't look at the code until we start the first exercise."
                    , bullet "Join the shared workspace and claim a board. Make independent notes on your board."
                    , bullet "After each exercise we'll copy any thoughts we want to share to a shared board."
                    ]
                , item (h2 [ style "margin-top" "-20px" ] [ text "Any questions before we start?" ]) |> hide
                ]
              )
            ]

        SessionStart { facilitatedBy, groupWorkspaceLink, annotationLink, pdfLink } ->
            [ ( False
              , [ slideHeading "Code Reading Club"
                , slideP ("Facilitators: " ++ facilitatedBy)
                , slideP "hello@codereading.club | https://codereading.club"
                , slideHr
                , bullets
                    [ bulletLink "Code of conduct" "https://codereading.club/conduct"
                    , bulletLink "Group workspace" groupWorkspaceLink
                    , bulletLink "Code in annotation tool" annotationLink
                    , if String.length pdfLink > 0 then
                        bulletLink "Example annotation" pdfLink

                      else
                        item (text "")
                    ]
                , slideHr
                , bullets
                    [ bullet "Grab a copy of the code"
                    , bullet "I'll keep the exercises & timer posted on my screenshare"
                    , bullet "Join the group workspace and claim a board"
                    , bullet "Make independent notes on your board"
                    , bullet "After each exercise we'll copy any thoughts we want to share to a shared board"
                    ]
                , item (h2 [ style "margin-top" "-20px" ] [ text "Any questions before we start?" ]) |> hide
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

        SecondThoughts ->
            [ ( True
              , [ slideHeading "Second thoughts?"
                , slideP "What's the most disorientating thing so far? This can be something about the Code Reading Club process or the code sample we are looking at."
                , slideP "Is something confusing or worrying you? Are you feeling excited or uneasy?"
                , container (div [])
                    [ timedHeading "2" "Independently" "Note down 1 or 2 things"
                    , item (img [ src "example-excited-worried.png", style "height" "250px" ] [])
                    ]
                ]
              )
            , ( True
              , [ slideHeading "Second thoughts?"
                , container (div [])
                    [ timedHeading "5" "Together" "Discuss"
                    , bullets
                        [ bullet "Give everyone a chance share if they want to"
                        , bullet "Discuss what you want to get out of the club"
                        , bullet "Think about how to accommodate members with varying levels of experience and confidence"
                        ]
                    ]
                ]
              )
            ]

        Reflect ->
            [ ( True
              , [ slideHeading "Reflect on the session"
                , slideP "If you have time, it's helpful to wrap up the session with a little reflection."
                , timedHeading "5" "Together" "Note down things"
                , bullets
                    [ bullet "that went well or felt good"
                    , bullet "you want to try to do differently next time because they didn't work or felt bad"
                    ]
                ]
              )
            ]

        Feedback ->
            [ ( True
              , [ slideHeading "Reflect on the session"
                , slideP "If you have time, it's helpful to wrap up the session with a little reflection."
                , timedHeading "5" "Together" "Note down things"
                , bullets
                    [ bullet "Feedback we can act on - both good and bad is helpful"
                    , bullet "Observations about the experience - in the club today or thoughts you've had between clubs"
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
                , slideP "Code reading club resources: https://codereading.club"
                , slideP "Read Felienne's book! The Programmer's Brain"
                , slideP "Start a club"
                , slideP "Join a club"
                , slideP "Get in touch hello@codereading.club"
                ]
              )
            ]

        -- First Look
        FirstGlance ->
            [ ( True
              , [ slideHeading "First glance"
                , slideP "The goal of this exercise is to practice to get a first impression of code and act upon that. We all have different instincts and strategies for where to start when faced with a new piece of code. It doesn't matter how trivial you think the first and second things you noticed are."
                , timedHeading "1" "Independently" "Glance at the code"
                , slideP "It's important that what you use is your  immediate reaction, don't overthink it!"
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

        Syntax ->
            [ ( True
              , [ slideHeading "Syntax knowledge"
                , slideP "The goal of this exercise is to practice to make sure everyone in club is familiar with syntactic elements of the code."
                , timedHeading "5" "Independently" "Examine syntax"
                , slideP "Look at the code and examine syntactic elements. Do you know the meaning of all elements?"
                , slideP "You can use these questions as a guide:"
                , bullets
                    [ bullet "Is it clear to you what the role of each block in the code is (function, condition, repetition etc)?"
                    , bullet "Do you recognize all operators?"
                    , bullet "Take the remainder of the time to think about what other things are unfamiliar."
                    ]
                ]
              )
            , ( True
              , [ slideHeading "Syntax knowledge"
                , timedHeading "5" "Together" "Discuss"
                , slideP "Talk about unfamiliar constructs."
                , slideP "Were there constructs that were unfamiliar?"
                , bullets
                    [ bullet "If so, are there members of the group who know the meaning?"
                    , bullet "If not, can you look up the constructs?"
                    ]
                , slideP "Why are the syntactic constructs unfamiliar?"
                , slideP "Are they ideosyncratic to this language or code base?"
                ]
              )
            ]

        AnnotateStructure { annotationLink, pdfLink } ->
            [ ( True
              , [ slideHeading "Code structure"
                , slideP "The goal of this exercise is to be a concrete thing to *do* when looking at new code for the first time. New code can be scary, doing something will help!"
                , timedHeading "8" "Independently" "Examine structure"
                , slideP "Highlight the places where they are defined a draw links to where they are used. Use 3 different colours."
                , item (img [ src "annotated-code.png", style "float" "right", style "height" "260px" ] [])
                , item (img [ src "scribbled-code.png", style "float" "right", style "height" "260px", style "margin" "-20px 20px 0 0" ] [])
                , bullets
                    [ bulletLink "Code to annotate" annotationLink
                    , if String.length pdfLink > 0 then
                        bulletLink "Code pdf to download" pdfLink

                      else
                        item (text "")
                    ]
                , bullets
                    [ bullet "Variables"
                    , bullet "Functions / Methods"
                    , bullet "Classes / Instantiation"
                    ]
                ]
              )
            , ( True
              , [ slideHeading "Code structure"
                , timedHeading "10" "Together" "Discuss"
                , bullets
                    [ bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
                    , bullet "What patterns are visible from the colors and links only?"
                    , bullet "How does the data flow through the code?"
                    , bullet "What parts of the code seem to warrant more attention?"
                    , bullet "Which colours did you choose to highlight each item?"
                    , bullet "What strategies did you use to identify different elements in the code?"
                    ]
                ]
              )
            ]

        ListNames ->
            [ ( True
              , [ slideHeading "Names"
                , timedHeading "5" "Independently" "Highlight"
                , slideP "Start by examining the names of things. This is one method for discovering how the code fits together and its intentions."
                , bullets
                    [ bullet "Can you identify any patterns?"
                    , bullet "Are there any anomolies?"
                    , bullet "What are the consequences in terms of readability?"
                    ]
                ]
              )
            , ( True
              , [ slideHeading "Names"
                , timedHeading "10" "Together" "Identify molds used"
                , slideP "This can be done with one person scribing while others call out examples."
                , bullets
                    [ bullet "What can we learn from these names?"
                    , bullet "Which elements are related to each other, from the names only?"
                    , bullet "Are there names that are ambiguous when looked at without context?"
                    ]
                ]
              )
            ]

        RandomLine ->
            [ ( True
              , [ slideHeading "Random Line"
                , timedHeading "5" "Independently" "Examine the line"
                , slideP "Select a random line from the code in whatever way you like. It can be helpful to randomly pick 3 line numbers and have the facilitator choose from them, which they think will be most interesting to talk about; but surprisingly, even a blank line can generate some conversation!"
                , slideP "Debugging often starts with a line number."
                , slideP "Start by looking at the line itself, then think about how it relates to the code around it."
                , bullets
                    [ bullet "What is the main idea of this line?"
                    , bullet "What lines does it relate to and why?"
                    , bullet "What strategies & prior knowlegde are you using to figure this out?"
                    ]
                ]
              )
            , ( True
              , [ slideHeading "The Line in Context"
                , timedHeading "8" "Together" "Discuss"
                , bullets
                    [ bullet "What is the 'scope' of the random line?"
                    , bullet "What part of the code was seen as related?"
                    , bullet "How does the line fit into the rest of the code base?"
                    ]
                , slideP "Take turns in the group, and let every member talk about the code for 30 seconds (could also be one sentence each). Try to add new information and not repeat things that have been said, and repeat until people do not know new things anymore or we run out of time.."
                ]
              )
            ]

        ImportantLines ->
            [ ( True
              , [ slideHeading "Content"
                , timedHeading "5" "Independently" "Identify important lines"
                , slideP "Important can mean whatever you want it to. If it's helpful, try to think of it as a line that you might highlight when reading a text."
                , bullets
                    [ bullet "Identify the 4 lines you consider most important"
                    , bullet "Note those lines down on your board"
                    , bullet "Think about why you chose them"
                    ]
                , slideP "We'll dot vote our line numbers together and discuss choices in the next exercise"
                ]
              )
            , ( True
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
              )
            ]

        Summarise ->
            [ ( True
              , [ slideHeading "Summary"
                , timedHeading "5" "Independently" "Summarise"
                , slideP "The goal of this exercise is to think about the core purpose or function of this code."
                , bullets
                    [ bullet "try to write down the essence of the code in a few sentences"
                    ]
                ]
              )
            , ( True
              , [ slideHeading "Summary"
                , timedHeading "8" "Together" "Discuss"
                , bullets
                    [ bullet "topics covered by many vs few"
                    , bullet "strategies used to create the summary (e.g. method names, documentation, variable names, prior knowledge of system)"
                    ]
                ]
              )
            ]

        -- Second Look
        RecapStructure importantLines ->
            [ ( True
              , [ slideHeading "Code structure"
                , timedHeading "5" "Independently" "Remember"
                , slideP "Look at the pieces that make up the code and how they connect or flow together. This exercise is meant as a recap of the first session on the code, and as a way to onboard people that might have missed the first session on this code snippet."
                , slideP "Looking at an annotated copy from the last session, make some notes about what parts of the code stand out and why. If you did not participate in the previous session, highlight the variables, methods and classes. Start to draw links between where they are instantiated and used."
                , bullets
                    [ bullet "Study the patterns and think about what they tell you."
                    ]
                , slideP "When we looked at this code last month, we talked about important lines together."
                , slideP ("These were chosen by a few people: " ++ String.join ", " (List.map String.fromInt importantLines))
                ]
              )
            , ( True
              , [ slideHeading "Code structure"
                , timedHeading "5" "Together" "Review & Summerise"
                , slideP "Someone who was in the previous session could summarise or where we got to or we could think about:"
                , bullets
                    [ bullet "What direction does the code flow in?"
                    , bullet "What parts stand out for lack, or excess, of links to other parts?"
                    , bullet "What parts of the code seem to warrant more attention?"
                    , bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
                    , bullet "What thoughts did you have when thinking about the structure?"
                    ]
                ]
              )
            ]

        CentralThemes ->
            [ ( True, [] ) ]

        CentralConcepts ->
            [ ( True, [] ) ]

        DecisionsMade ->
            [ ( True
              , [ slideHeading "The decisions made in the code"
                , timedHeading "5" "Independently" "Consider code choices"
                , slideP "Reexamine the code snippet and list decisions of the creator(s) of the code, for example a decision to use a certain design pattern or use a certain library or API."
                , bullets
                    [ bullet "Try not to judge the decisions as good or bad"
                    , bullet "Focus on what decisions the developer(s) had to make, not why they made them"
                    ]
                , item (img [ src "example-code-decisions.png", style "height" "250px" ] [])
                ]
              )
            , ( True
              , [ slideHeading "The decisions made in the code"
                , timedHeading "10" "Together" "Discuss"
                , bullets
                    [ bullet "Decisions covered by many vs few"
                    , bullet "Strategies used to decide (e.g. method names, documentation, variable names, prior knowledge of system)"
                    ]
                ]
              )
            ]

        DecisionsConsequences ->
            [ ( True
              , [ slideHeading "Consequences of the decisions"
                , timedHeading "5" "Independently" "Consider the consequences"
                , slideP "Think about the consequences of the decisions that were made. These could be the decisions you found yourself in the previous exercise or a decision someone else pointed out."
                , slideP "You might want to think consider the impact of the decisions this code on:"
                , bullets
                    [ bullet "readability"
                    , bullet "performance"
                    , bullet "extendability"
                    ]
                , item (img [ src "example-consequences.png", style "height" "210px" ] [])
                ]
              )
            , ( True
              , [ slideHeading "Consequences of the decisions"
                , timedHeading "10" "Together" "Discuss"
                , bullets
                    [ bullet "Consequences covered by many vs few"
                    , bullet "Different types of consequence chosen (e.g. readability, extendability, performance)"
                    , bullet "Pros of these decisions"
                    , bullet "Possible cons of these decisions"
                    ]
                ]
              )
            ]

        DecisionsWhy ->
            [ ( True
              , [ slideHeading "The 'why' of the decisions"
                , timedHeading "10" "Together" "Make statements"
                , slideP "Can you understand why the code was designed this way?"
                , bullets
                    [ bullet "What assumptions do these decisions rely on?"
                    , bullet "Can you think of reasons these decisions might have been made?"
                    , bullet "What alternatives would have been possible?"
                    ]
                ]
              )
            ]



-- Markup helpers


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
                            [ text "Slides for this workshop: https://runner.codereading.club"
                            ]
                        )
                   ]
            )
        ]

module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Html exposing (Html, a, img, button, div, h1, h2, hr, li, p, span, text, ul)
import Html.Attributes exposing (src, class, href, style)
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
    [ [ slideHeading "Code Reading Club introduction"
      , slideP "Facilitators: Dan, Katja and Nick"
      , slideP "email: hello@code-reading.org"
      , slideP "website: https://code-reading.org"
      , slideHr
      , bullets
            [ bulletLink "Code of conduct" "https://code-reading.org/conduct"
            , bulletLink "Miro board" "https://miro.com/welcomeonboard/d0lFUzJmVEJaV3VYU1g4RmRoOFE4UzNJT2tHazNRSTd6T1hjZVVtNGhsWmd5WE5xV2Z3ZDI0OWxjTno4Yk1rUXwzMDc0NDU3MzQ5MTgyMDYwNDgy"
            , bulletLink "Code in annotation tool" "https://annotate.code-reading.org/#/file/IYBxCcHsDdgGwM4HoCCYqzgFQKYIC4IB0AUsLEgEZySVIDGAbPQJwDMAjACaNf0AM-FgCYA7Dn71h9LlwAsAVnH8AHFw4rhbYcAULgfJKAgx4+PISQJw9JAFtgASwB2SAFblgSSOADmR9FM4cwJkekg7ShdgfEdIZ2QAYQio5xi4hIAJHDgQHHAiD1ggA"
            , bulletLink "Code pdf to download" "https://katj.am/code.pdf"
            ]
      ]
    , [ slideHeading "Why are we doing this?"
      , slideP "Take a few minutes to talk about your motivation for doing the club. This is important because it will help you support each other and make it more likely that your group will feel that the club sessions have value for them."
      , container (div [])
            [ timedHeading "2" "Independently" "Note down one thing"
            , bullets [ bullet "that you are looking forward to or excited about", bullet "that you are worried or confused about" ]
            , item (img [src "example-excited-worried.png", style "height" "250px"][])
            ]
            |> hide
      ]
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
    , [ slideHeading "How will this work?"
      , bullets
            [ bullet "Grab a copy of the code (paper or digital annotation)"
            , bullet "I'll keep the exercises & timer posted on my screen"
            , bullet "Join the miro and claim a board"
            , bulletLink "Miro board" "https://miro.com/welcomeonboard/d0lFUzJmVEJaV3VYU1g4RmRoOFE4UzNJT2tHazNRSTd6T1hjZVVtNGhsWmd5WE5xV2Z3ZDI0OWxjTno4Yk1rUXwzMDc0NDU3MzQ5MTgyMDYwNDgy"
            , bullet "You can add notes and annotate your copy of the code there"
            ]
      , item (h2 [] [ text "Any questions before we start?" ]) |> hide
      ]
    , [ slideHeading "Code structure"
      , timedHeading "10" "Together" "Review & discuss"
      ,slideP "We look at the pieces that make up the code and how they connect or flow together. This exercise is meant as a recap of the first session on the code, and as a way to onboard people that might have missed the first session on this code snippet."
      , slideP "If you have an annotated copy from the last session, look at that and make some notes about what parts of the code stand out and why."
      , slideP "If you haven't got one, or did not participate in the previous session, use this time to highlight the variables, methods and classes. Draw links between where they are instantiated and used."
      , bullets [  bullet "Study the patterns and think about what they tell you."
                , bullet "What direction does the code flow in?"
                , bullet "What parts stand out for lack, or excess, of links to other parts?"
                ,bullet "What parts of the code seem to warrant more attention?"
                ,bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
                , bullet "What thoughts did you have when thinking about the structure?"
            ]
      ]
    , [ slideHeading "Important lines"
      , timedHeading "3" "Together" "Share important lines chosen"
      , slideP "When we looked at this code last month, we chose some important lines together."
      , Markdown.toHtml [] ("```15 public static <IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9, OUT> void verifyAllCombinations(```") |> item
      , Markdown.toHtml [] ("```39 doForAllCombinations(parameters1, parameters2, parameters3, parameters4, parameters5, parameters6, parameters7,```") |> item
      , Markdown.toHtml [] ("```42 Approvals.verify(output, options); ```") |> item
      , Markdown.toHtml [] ("```45 public static <IN1, IN2, IN3, IN4, IN5, IN6, IN7, IN8, IN9> void doForAllCombinations(IN1[] parameters1,```") |> item
      , Markdown.toHtml [] ("```68 action.call(in1, in2, in3, in4, in5, in6, in7, in8, in9);```") |> item
      ]
    , [ slideHeading "The decisions made in the code"
      , timedHeading "5" "Independently" "Consider code choices"
      , slideP "Reexamine the code snippet and list decisions of the creator(s) of the code, for example a decision to use a certain design pattern or use a certain library or API."
      , bullets
            [ bullet "Try not to judge the decisions as good or bad"
            , bullet "Focus on what decisions the developer(s) had to make, not why they made them"
            ]
            , item (img [src "example-code-decisions.png", style "height" "250px"][])
      ]
    , [ slideHeading "The decisions made in the code"
      , timedHeading "10" "Together" "Discuss"
      , bullets
            [ bullet "Decisions covered by many vs few"
            , bullet "Strategies used to decide (e.g. method names, documentation, variable names, prior knowledge of system)"
            ]
      ]
    , [ slideHeading "Consequences of the decisions"
      , timedHeading "5" "Independently" "Consider the consequences"
      , slideP "Think about the consequences of the decisions that were made. These could be the decisions you found yourself in the previous exercise or a decision someone else pointed out."
      , slideP "You might want to think consider the impact of the decisions this code on:"
      , bullets
            [ bullet "readability"
            , bullet "performance"
            , bullet "extendability"
            ]
      , item (img [src "example-consequences.png", style "height" "210px"][])
      ]
    , [ slideHeading "Consequences of the decisions"
      , timedHeading "10" "Together" "Discuss"
      , bullets
            [ bullet "Consequences covered by many vs few"
            , bullet "Different types of consequence chosen (e.g. readability, extendability, performance)"
            , bullet "Pros of these decisions"
            , bullet "Possible cons of these decisions"
            ]
      ]
    , [ slideHeading "The 'why' of the decisions"
      , timedHeading "10" "Together" "Make statements"
      , slideP "Can you understand why the code was designed this way?"
      , bullets
            [ bullet "What assumptions do these decisions rely on?"
            , bullet "Can you think of reasons these decisions might have been made?"
            , bullet "What alternatives would have been possible?"
            ]
      , slideP ""
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
      , slideP "Code used for this session..."
      , slideP "over to Llewelyn!"
      , bullets
            [ bulletLink "Java combinations helper from https://approvaltests.com/" "https://github.com/approvals/ApprovalTests.Java/blob/36b68f2b6e5978e43ef2a52ebed56944a56136bf/approvaltests/src/main/java/org/approvaltests/combinations/CombinationsHelper.java"
            ]
      , slideP "Code reading club resources: https://code-reading.org"
      , slideP "Read Felienne's book! The Programmer's Brain"
      , slideP "Start a club"
      , slideP "Join a club"
      , slideP "Get in touch hello@code-reading.org"
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

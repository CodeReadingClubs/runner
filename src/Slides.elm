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
    [ [ slideHeading "Code Reading Club introduction"
      , slideP "Facilitators: Felienne, Dan, Katja and Nick"
      , slideP "email: hello@code-reading.org"
      , slideP "website: https://code-reading.org"
      , slideHr
      , bullets
            [ bulletLink "Miro board" "https://miro.com/welcomeonboard/QkV5Y0ZXZERKeGJHOXNoczFWSFp3d3BLZW9oQzJEZE5hMVBJNEY1ZFliTTllenJRdzBlOVVYQmJmQ204SzdRNHwzMDc0NDU3MzQ5MTgyMDYwNDgy"
            , bulletLink "Code pdf to download" "https://github.com/CodeReadingClubs/Resources/raw/trunk/StarterKit/Session2/code.pdf"
            ]
      ]
    , [ slideHeading "Why are we doing this?"
      , slideP "Take a few minutes to talk about your motivation for doing the club. This is important because it will help you support each other and make it more likely that your group will feel that the club sessions have value for them."
      , container (div [])
            [ timedHeading "2" "Independently" "Note down one thing"
            , bullets [ bullet "that you are looking forward to or excited about", bullet "that you are worried or confused about" ]
            ]
            |> hide
      ]
    , [ slideHeading "Why are we doing this?"
      , container (div [])
            [ timedHeading "5" "Together" "Discuss"
            , bullets
                [ bullet "Give everyone a chance to read out their hopes and fears"
                , bullet "Discuss collectively what you want to get out of the club"
                , bullet "Decide how long and how often you want your sessions to be"
                , bullet "Decide if the same person will always facilitate or if you want to take turns"
                , bullet "Think about how to accommodate members of your group who might have varying levels of experience and confidence"
                ]
            ]
      ]
    , [ slideHeading "How this will work?"
      , bullets
            [ bullet "Grab a copy of the code"
            , bullet "I'll keep the exercises & timer posted on my screenshare"
            , bullet "Join the miro and claim a board"
            , bulletLink "Miro board" "https://miro.com/welcomeonboard/QkV5Y0ZXZERKeGJHOXNoczFWSFp3d3BLZW9oQzJEZE5hMVBJNEY1ZFliTTllenJRdzBlOVVYQmJmQ204SzdRNHwzMDc0NDU3MzQ5MTgyMDYwNDgy"
            , bullet "You can add notes and annotate your copy of the code there"
            ]
      , item (h2 [] [ text "Any questions before we start?" ]) |> hide
      ]
    , [ slideHeading "Code structure"
      , slideP "We look at the pieces that make up the code and how they connect or flow together. This exercise is meant as a recap of the first session on the code, and as a way to onboard people that might have missed the first session on this code snippet."
      , timedHeading "5" "Independently" "Examine structure"
      , slideP "If you have an annotated copy from the last session, look at that and make some notes about what parts of the code stand out and why."
      , slideP "If you haven't got one, or did not participate in the previous session, use this time to highlight the variables, methods and classes. Draw links between where they are instantiated and used."
      , slidePMarkdown "[Annotated code](https://www.goodannotations.com/project/9QLhBgPoF5SK2UBm1J3arBakBz32/7KFxWkwq5O)"
      , bullets
            [ bullet "Study the patterns and think about what they tell you."
            , bullet "What direction does the code flow in?"
            , bullet "What parts stand out for lack, or excess, of links to other parts?"
            ]
      ]
    , [ slideHeading "Code structure"
      , timedHeading "10" "Together" "Discuss"
      , bullets
            [ bullet "Did anyone have trouble deciding what constituted a variable, function or class?"
            , bullet "What parts of the code seem to warrant more attention?"
            , bullet "What parts did many or only a few people mention?"
            , bullet "What thoughts did you have when thinking about the structure?"
            ]
      ]
    , [ slideHeading "Random line"
      , timedHeading "3" "Independently" "Examine this line"
      , slideP "Select a random line from the code in whatever way you like. It can be helpful to randomly pick 3 line numbers and have the facilitator choose from them, which they think will be most interesting to talk about; but surprisingly, even a blank line can generate some conversation!"
      , bullets
            [ bullet "What is the main idea of this line?"
            , bullet "What lines does it relate to and why?"
            ]
      ]
    , [ slideHeading "The line in context"
      , timedHeading "5" "Together" "Discuss in group"
      , bullets
            [ bullet "What is the 'scope' of the random line?"
            , bullet "What part of the code was seen as related?"
            , bullet "How does the line fit into the rest of the code base?"
            ]
      ]
    , [ slideHeading "Summerise for people not here last time"
      , timedHeading "4" "One person" "Essence of the code"
      , slideP "Explain in brief what the code does."
      , slideP "This code is written in javascript for the popular moment library and can be found:" |> hide
      , slidePMarkdown "[moment/src/lib/create/from-anything.js](https://github.com/moment/src/lib/create/from-anything.js)" |> hide
      ]
    , [ slideHeading "The decisions made in the code"
      , timedHeading "5" "Independently" "Consider code choices"
      , slideP "Reexamine the code snippet and list decisions of the creator(s) of the code, for example a decision to use a certain design pattern or use a certain library or API."
      , bullets [bullet "Try not to judge the decisions as good or bad"
      , bullet "Focus on what decisions the developer(s) had to make, not why they made them"
      ]
    , [ slideHeading "The decisions made in the code"
      , timedHeading "5" "Together" "Discuss"
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
      ]
    , [ slideHeading "Consequences of the decisions"
      , timedHeading "5" "Together" "Discuss"
      , bullets
            [ bullet "Consequences covered by many vs few"
            , bullet "Different 'ilities' chosen"
            , bullet "Pros of these decisions"
            , bullet "Possible cons of these decisions"
            ]
      ]
    , [ slideHeading "The 'why' of the decisions"
      , timedHeading "5" "Together" "Make statements"
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
      , bullets
            [ bulletLink "moment: from-anything.js" "https://github.com/moment/moment/blob/52019f1dda47c3e598aaeaa4ac89d5a574641604/src/lib/create/from-anything.js"
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

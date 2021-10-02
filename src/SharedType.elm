module SharedType exposing (..)

import SliceShow.Content
import SliceShow.Slide
import Time


type alias Model =
    { displayTime : Float
    , startTime : Float
    , timerStarted : Bool
    }


type Message
    = Tick Time.Posix
    | AddStartMinute
    | StartStopPressed Bool


type alias CustomSlide =
    SliceShow.Slide.Slide Model Message


type alias CustomContent =
    SliceShow.Content.Content Model Message



-- Slide config types


type alias StartInfo =
    { facilitatedBy : String
    , miroLink : String
    , annotationLink : String
    , pdfLink : String
    }

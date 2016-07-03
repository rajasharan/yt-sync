module Types exposing (..)

import Time exposing (Time)

type alias Url = String
type alias Model =
    { url : Url -- youtube video url
    , err : String -- errors from ports
    , server : String -- websocket server
    , play : Bool -- play/pause toggle
    , total : Float -- total playback time
    , width : Int -- seekbar width
    , cursorWidth : Float
    }

type Msg = Load String
         | Click
         | Error String
         | Play Float
         | Pause Float
         | Seek Float
         | Total Float
         | Width Int
         | Resize
         | Tick
         | PlayCursor Float
         | MoveCursor Float


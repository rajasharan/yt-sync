module Types exposing (..)

import Time exposing (Time)

type alias Url = String
type alias Model =
    { url : Url -- youtube video url
    , err : String -- errors from ports
    , server : String -- websocket server
    , isPlaying : Bool -- play/pause toggle
    , total : Float -- total playback time
    , width : Int -- seekbar width
    , cursorWidth : Float -- playback cursor position
    , seek : Float
    }

createModel : Model
createModel =
    { url = ""
    , err = ""
    , server = ""
    , isPlaying = False
    , total = 0.0
    , width = 1000
    , cursorWidth = 0.0
    , seek = 0.0
    }

type Msg = Load String
         | TogglePlay
         | Error String
         | Play Float
         | Pause Float
         | Seek Float
         | Total Float
         | Width Int
         | Resize
         | Tick
         | UpdateSeekBar Float
         | Listen String
         | SeekBar String

type alias SocketMsg =
    { kind : SocketKind
    , url : Url
    , play : Bool
    , seek : Float
    }

type SocketKind = Connection | LoadVideo | PlayPause | SeekPosition

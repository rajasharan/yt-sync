module Types exposing (..)

import Time exposing (Time)

type alias Model =
    { vId : String -- youtube video_id
    , load : Bool -- flag to load iframe
    , err : String -- errors from ports
    , server : String -- websocket server
    , isPlaying : Bool -- play/pause toggle
    , total : Float -- total playback time
    , seek : Float -- playback cursor position
    }

createModel : Model
createModel =
    { vId = ""
    , load = False
    , err = ""
    , server = ""
    , isPlaying = False
    , total = 0.0
    , seek = 0.0
    }

type Msg = UrlInput String
         | Load Int
         | TogglePlay
         | Error String
         | PlayerState Bool
         | Play Float
         | Pause Float
         | Seek Float
         | Total Float
         | Tick
         | UpdateSeekBar Float
         | Listen String
         | SeekBar String

type alias SocketMsg =
    { kind : SocketKind
    , vId : String
    , play : Bool
    , seek : Float
    }

type SocketKind = Connection | LoadVideo | PlayPause | SeekPosition

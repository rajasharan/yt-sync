module Encoders exposing (..)

import Json.Encode as Json exposing (..)
import Types exposing (..)

encodeSocketMsg : SocketMsg -> String
encodeSocketMsg msg =
    case msg.kind of
        LoadVideo -> encode 0 (object [("kind", string "LoadVideo"), ("url", string msg.url), ("play", null), ("seek", null)])
        PlayPause -> encode 0 (object [("kind", string "PlayPause"), ("url", null), ("play", bool msg.play), ("seek", null)])
        SeekPosition -> encode 0 (object [("kind", string "MoveCursor"), ("url", null), ("play", null), ("seek", float msg.seek)])

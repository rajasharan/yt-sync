module Encoders exposing (encodeSocketMsg)

import Json.Encode as Json exposing (..)
import Types exposing (..)

encodeSocketMsg : SocketMsg -> String
encodeSocketMsg msg =
    case msg.kind of
        Connection -> encode 0 (object [("kind", string "Connection"), ("url", string ""), ("play", bool False), ("seek", float 0.0)])
        LoadVideo -> encode 0 (object [("kind", string "LoadVideo"), ("url", string msg.url), ("play", bool False), ("seek", float 0.0)])
        PlayPause -> encode 0 (object [("kind", string "PlayPause"), ("url", string ""), ("play", bool msg.play), ("seek", float 0.0)])
        SeekPosition -> encode 0 (object [("kind", string "SeekPosition"), ("url", string ""), ("play", bool False), ("seek", float msg.seek)])

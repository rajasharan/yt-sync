module Encoders exposing (send)

import Json.Encode as Json exposing (..)
import WebSocket as WS

import Types exposing (..)

encodeSocketMsg : SocketMsg -> String
encodeSocketMsg msg =
    case msg.kind of
        Connection -> encode 0 (object [("kind", string "Connection"), ("url", string ""), ("play", bool False), ("seek", float 0.0)])
        LoadVideo -> encode 0 (object [("kind", string "LoadVideo"), ("url", string msg.url), ("play", bool False), ("seek", float 0.0)])
        PlayPause -> encode 0 (object [("kind", string "PlayPause"), ("url", string ""), ("play", bool msg.play), ("seek", float 0.0)])
        SeekPosition -> encode 0 (object [("kind", string "SeekPosition"), ("url", string ""), ("play", bool False), ("seek", float msg.seek)])

send : SocketKind -> Model -> Cmd Msg
send kind model =
    encodeSocketMsg
        { kind = kind
        , url = model.url
        , play = model.isPlaying
        , seek = model.seek
        }
    |> WS.send model.server

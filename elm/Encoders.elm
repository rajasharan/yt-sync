module Encoders exposing (send)

import Json.Encode as Json exposing (..)
import WebSocket as WS

import Types exposing (..)

encodeSocketMsg : SocketMsg -> String
encodeSocketMsg msg =
    case msg.kind of
        Connection -> encode 0 (object [("kind", string "Connection"), ("url", string ""), ("play", bool False), ("seek", float 0.0)])
        LoadVideo -> encode 0 (object [("kind", string "LoadVideo"), ("url", string msg.vId), ("play", bool msg.play), ("seek", float msg.seek)])
        PlayPause -> encode 0 (object [("kind", string "PlayPause"), ("url", string msg.vId), ("play", bool msg.play), ("seek", float msg.seek)])
        SeekPosition -> encode 0 (object [("kind", string "SeekPosition"), ("url", string msg.vId), ("play", bool msg.play), ("seek", float msg.seek)])
        NextVideo -> encode 0 (object [("kind", string "NextVideo"), ("url", string msg.vId), ("play", bool msg.play), ("seek", float msg.seek)])

send : SocketKind -> Model -> Cmd Msg
send kind model =
    encodeSocketMsg
        { kind = kind
        , vId = model.vId
        , play = model.isPlaying
        , seek = model.seek
        }
    |> WS.send model.server

module Decoders exposing (decodeSocketMsg)

import Json.Decode as Json exposing (..)
import String exposing (..)

import Types exposing (..)
import Utils exposing (..)
import Ports

decodeSocketMsg : String -> Model -> (Model, Cmd Msg)
decodeSocketMsg str model =
    let
        --_ = Debug.log "socket model" model
        kind = ("kind" := string)
               `Json.andThen`
               (\s ->
                   if contains s "Connection" then
                       succeed Connection
                   else if contains s "LoadVideo" then
                       succeed LoadVideo
                   else if contains s "PlayPause" then
                       succeed PlayPause
                   else if contains s "SeekPosition" then
                       succeed SeekPosition
                   else
                       fail "unknown SocketKind message"
               )
        url = "url" := string
        play = "play" := bool
        seek = "seek" := float
        socketMsgDecoder = object4 SocketMsg kind url play seek
        value = decodeString socketMsgDecoder str
    in
        case value of
            Ok v -> parse v model
            Err err -> { model | err = err } ! []

parse : SocketMsg -> Model -> (Model, Cmd Msg)
parse msg model =
    case msg.kind of
        Connection -> Debug.log "connected" model ! []
        LoadVideo -> Debug.log "decoded Model" { model | url = getVideoId msg.url, err = "" } ! []
        PlayPause -> { model | play = msg.play } ! [ if msg.play then Ports.pause () else Ports.play () ]
        SeekPosition -> { model | cursorWidth = msg.seek } ! [ Ports.seek <| convertWidthToSecods msg.seek model ]

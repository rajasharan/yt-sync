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
                   else if contains s "NextVideo" then
                       succeed NextVideo
                   else
                       fail "unknown SocketKind message"
               )
        vId = "url" := string
        play = "play" := bool
        seek = "seek" := float
        socketMsgDecoder = object4 SocketMsg kind vId play seek
        value = decodeString socketMsgDecoder str
    in
        case value of
            Ok v -> parse v model
            Err err -> { model | err = err } ! []

parse : SocketMsg -> Model -> (Model, Cmd Msg)
parse msg model =
    case msg.kind of
        Connection -> Debug.log "connected" model ! []
        LoadVideo -> { model | vId = msg.vId, err = "" } ! [ Ports.load msg.vId ]
        PlayPause -> model ! [ if msg.play then Ports.pause () else Ports.play () ]
        SeekPosition -> { model | seek = msg.seek } ! [ Ports.seek msg.seek ]
        NextVideo -> { model | vId = msg.vId } ! [ Ports.nextVideo <| Utils.toInt msg.vId ]

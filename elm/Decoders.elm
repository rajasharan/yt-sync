module Decoders exposing (decodeSocketMsg)

import Json.Decode as Json exposing (..)
import List.Extra exposing (..)
import String exposing (..)

import Types exposing (..)
import Ports exposing (..)

decodeSocketMsg : String -> Model -> (Model, Cmd Msg)
decodeSocketMsg str model =
    let
        _ = Debug.log "socket model" model
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

--decodeKind : Decoder SocketKind
--decodeKind = ("kind" := string) 

parse : SocketMsg -> Model -> (Model, Cmd Msg)
parse msg model =
    let
        head' maybe =
            case maybe of
                Just str -> str
                Nothing -> ""

        getVideoId url =
            if contains "v=" url then
                head' ((getAt 1 <| split "v=" url) `Maybe.andThen` (\s -> getAt 0 (split "&" s)))
            else
                url

        cursor sec model =
            sec * (Basics.toFloat model.width) / model.total

        seek pos model =
            pos * model.total / (Basics.toFloat model.width)
    in
    case msg.kind of
        Connection -> Debug.log "connected" model ! []
        LoadVideo -> Debug.log "decoded Model" { model | url = getVideoId msg.url, err = "" } ! []
        PlayPause -> { model | play = msg.play } ! [ if msg.play then pause () else play () ]
        SeekPosition -> { model | cursorWidth = msg.seek } ! [ Ports.seek <| seek msg.seek model ]

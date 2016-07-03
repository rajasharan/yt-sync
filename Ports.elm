port module Ports exposing (..)

port play : () -> Cmd msg
port pause : () -> Cmd msg
port seek : Float -> Cmd msg
port total : () -> Cmd msg

port played : (Float -> msg) -> Sub msg
port paused : (Float -> msg) -> Sub msg
port seeked : (Float -> msg) -> Sub msg
port totaled : (Float -> msg) -> Sub msg
port errored : (String -> msg) -> Sub msg

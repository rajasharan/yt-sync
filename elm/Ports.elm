port module Ports exposing (..)

port load : String -> Cmd msg
port play : () -> Cmd msg
port pause : () -> Cmd msg
port seek : Float -> Cmd msg
port total : () -> Cmd msg
port width : () -> Cmd msg
port time : () -> Cmd msg

port playing : (Bool -> msg) -> Sub msg
port played : (Float -> msg) -> Sub msg
port paused : (Float -> msg) -> Sub msg
port seeked : (Float -> msg) -> Sub msg
port totaled : (Float -> msg) -> Sub msg
port errored : (String -> msg) -> Sub msg
port seekbarWidth : (Int -> msg) -> Sub msg
port getTime : (Float -> msg) -> Sub msg

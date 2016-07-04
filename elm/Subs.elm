module Subs exposing (subs)

import Types exposing (..)
import WebSocket exposing (..)
import Time exposing (..)
import Window exposing (..)

import Ports exposing (..)

subs : Model -> Sub Msg
subs model =
    let
        times =
            if model.total > 0 && model.play then
                every (500 * millisecond) (\t -> Tick)
            else
                Sub.none
    in
    Sub.batch
        [ errored Error
        , played Play
        , paused Pause
        , seeked Seek
        , totaled Total
        , seekbarWidth Width
        , resizes (\s -> Resize)
        , times
        , getTime CheckCursor
        , listen model.server Listen
        ]

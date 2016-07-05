module Subs exposing (subs)

import Types exposing (..)
import WebSocket exposing (..)
import Time exposing (..)

import Ports exposing (..)

subs : Model -> Sub Msg
subs model =
    let
        times =
            if model.total > 0 && model.isPlaying then
                every (500 * millisecond) (\t -> Tick)
            else
                Sub.none
    in
    Sub.batch
        [ errored Error
        , playing PlayerState
        , played Play
        , paused Pause
        , seeked Seek
        , totaled Total
        , times
        , getTime UpdateSeekBar
        , listen model.server Listen
        ]

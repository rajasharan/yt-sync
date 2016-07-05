module Update exposing (update)

import String

import Types exposing (..)
import Utils exposing (..)
import Encoders exposing (send)
import Decoders exposing (decodeSocketMsg)
import Ports

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        secs str = secs' <| String.toFloat str
        secs' res =
            case res of
                Ok f -> f
                Err e -> 0.0
    in
    case msg of
        UrlInput url -> { model | vId = getVideoId url, err = "" } ! []

        Load key ->
            if key == 13 then
                Debug.log "vId" { model | load = True } ! [ Ports.load model.vId, send LoadVideo model ]
            else
                { model | load = False } ! []

        TogglePlay -> model
                    ! [ if model.isPlaying then Ports.pause () else Ports.play ()
                      , send PlayPause model
                      ]

        Error err -> { model | err = "Please reload!!! " ++ err } ! []
        PlayerState isPlaying -> { model | isPlaying = isPlaying } ! []
        Play time -> { model | isPlaying = True } ! []
        Pause time -> { model | isPlaying = False } ! []
        Seek time -> model ! []
        Total time -> { model | total = time } ! [ Ports.width () ]
        Width w -> { model | width = w } ! []
        Resize -> model ! [ Ports.width (), Ports.time () ]
        Tick -> model ! [ Ports.time () ]
        UpdateSeekBar sec -> { model | seek = sec } ! []

        SeekBar str -> { model | seek = secs str }
                     ! [ Ports.seek <| secs str
                       , send SeekPosition { model | seek = secs str }
                       ]

        Listen str -> decodeSocketMsg str model

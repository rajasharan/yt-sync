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
        Load url -> Debug.log "url" { model | url = getVideoId url, err = "" }
                  ! [ send LoadVideo { model | url = getVideoId url, err = "" } ]

        TogglePlay -> { model | play = not model.play }
                    ! [ if model.play then Ports.pause () else Ports.play ()
                      , send PlayPause model
                      ]

        Error err -> { model | err = err ++ " Please reload!!!" } ! []
        Play time -> model ! []
        Pause time -> model ! []
        Seek time -> model ! []
        Total time -> Debug.log "total" { model | total = time } ! [ Ports.width () ]
        Width w -> { model | width = w } ! []
        Resize -> model ! [ Ports.width (), Ports.time () ]
        Tick -> model ! [ Ports.time () ]
        UpdateSeekBar sec -> { model | seek = sec } ! []

        SeekBar str -> { model | seek = secs str }
                     ! [ Ports.seek <| secs str
                       , send SeekPosition { model | seek = secs str }
                       ]

        Listen str -> decodeSocketMsg str model

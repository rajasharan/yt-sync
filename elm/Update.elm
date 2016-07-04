module Update exposing (update)

import WebSocket exposing (send)

import Types exposing (..)
import Utils exposing (..)
import Encoders exposing (encodeSocketMsg)
import Decoders exposing (decodeSocketMsg)
import Ports

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Load url -> Debug.log "url" { model | url = getVideoId url, err = "" }
                  ! [ encodeSocketMsg
                        { kind = LoadVideo
                        , url = url
                        , play = model.play
                        , seek = model.cursorWidth
                        }
                        |> send model.server
                    ]

        TogglePlay -> { model | play = not model.play }
                    ! [ if model.play then Ports.pause () else Ports.play ()
                      , encodeSocketMsg
                          { kind = PlayPause
                          , url = model.url
                          , play = model.play
                          , seek = model.cursorWidth
                          }
                          |> send model.server
                      ]

        Error err -> { model | err = err ++ " Please reload!!!" } ! []
        Play time -> model ! []
        Pause time -> model ! []
        Seek time -> model ! []
        Total time -> Debug.log "total" { model | total = time } ! [ Ports.width () ]
        Width w -> { model | width = w } ! []
        Resize -> model ! [ Ports.width (), Ports.time () ]
        Tick -> model ! [ Ports.time () ]
        CheckCursor sec -> { model | cursorWidth = convertSecondsToWidth sec model } ! []

        MoveCursor pos -> { model | cursorWidth = pos }
                        ! [ Ports.seek <| convertWidthToSecods pos model
                          , encodeSocketMsg
                              { kind = SeekPosition
                              , url = model.url
                              , play = model.play
                              , seek = pos
                              }
                              |> send model.server
                          ]

        Listen str -> decodeSocketMsg str model

import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import List.Extra exposing (..)
import String exposing (..)
import Mouse exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Window exposing (..)
import Time exposing (..)
import Color exposing (..)
import Json.Decode exposing (..)
import WebSocket exposing (..)

import Types exposing (..)
import Ports exposing (..)
import Encoders exposing (..)
import Decoders exposing (..)

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

init : (Model, Cmd Msg)
init = ( { url = ""
         , err = ""
         , server = "ws://192.168.1.5:5000/"
         , play = False
         , total = 0.0
         , width = 1000
         , cursorWidth = 0.0
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
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
                    ! [ if model.play then pause () else play ()
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
        CheckCursor sec -> { model | cursorWidth = cursor sec model } ! []

        MoveCursor pos -> { model | cursorWidth = pos }
                        ! [ Ports.seek <| seek pos model
                          , encodeSocketMsg
                              { kind = SeekPosition
                              , url = model.url
                              , play = model.play
                              , seek = pos
                              }
                              |> send model.server
                          ]

        Listen str -> decodeSocketMsg str model

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

view : Model -> Html Msg
view model =
    let
        attrs =
            [ src <| "https://www.youtube.com/embed/"
                  ++ model.url
                  ++ "?enablejsapi=1"
                  ++ "&controls=0"
                  ++ "&fs=1"
                  ++ "&showinfo=1"
            , id "iframe"
            ]
    in
    div [class "container"]
      [ header model
      , Html.span [class "help is-danger"] [Html.text model.err]
      , section [class "hero"]
          [ div [class "hero-body"]
              [ div [class "container"]
                  [ div [id "video-wrapper", class "video-wrapper", onClick TogglePlay]
                      [ iframe attrs [] ]
                  ]
              ]
          ]
        , seekbar model
      --, footer model
      ]

header : Model -> Html Msg
header model =
    p [class "control has-addons has-addons-centered nav nav-item"]
      [ button [class "button is-info is-large", disabled True] [Html.text "youtube link"]
      , input
          [ class "input is-large is-expanded"
          , type' "text"
          , placeholder "Enter youtube link"
          , onInput Load
          ] []
      ]

seekbar : Model -> Html Msg
seekbar model =
    let
        form1 = rect model.cursorWidth 20
              |> filled (rgb 200 100 50)
        form2 = rect (Basics.toFloat model.width - model.cursorWidth) 20
               |> outlined defaultLine
        form = rect model.cursorWidth 20
               |> filled (rgb 200 50 50)
    in
      div [ class "seekbar"
          , on "click" (object1 MoveCursor ("offsetX" := float))
          ] 
        [ collage (round model.cursorWidth) 20 [form]
          |> toHtml
        ]

footer : Model -> Html Msg
footer model =
    p [class "nav nav-item"] [Html.text model.url]

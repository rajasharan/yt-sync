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

import Types exposing (..)
import Ports exposing (..)

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
         , server = ""
         , play = False
         , total = 0.0
         , width = 1000
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
    in
    case msg of
        Load url -> Debug.log "url" { model | url = getVideoId url } ! [ total () ]
        Click -> { model | play = if model.play then False else True } ! [ if model.play then pause () else play () ]
        Error err -> { model | err = err ++ " Please reload!!!" } ! []
        Play time -> model ! []
        Pause time -> model ! []
        Seek time -> model ! []
        Total time -> { model | total = time } ! [ Ports.width () ]
        Width w -> { model | width = w } ! []
        Resize -> model ! [ Ports.width () ]

subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ errored Error
        , played Play
        , paused Pause
        , seeked Seek
        , totaled Total
        , seekbarWidth Width
        , resizes (\s -> Resize)
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
      [ header
      , section [class "hero"]
          [ div [class "hero-body"]
              [ div [class "container"]
                  [ div [id "video-wrapper", class "video-wrapper", onClick Click]
                      [ iframe attrs [] ]
                  ]
              ]
          ]
        , seekbar model
      --, footer model
      ]

header : Html Msg
header =
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
        form = rect (Basics.toFloat model.width) 20
               |> outlined defaultLine
    in
      div [class "seekbar"] 
        [ collage model.width 20 [form]
          |> toHtml
        ]

footer : Model -> Html Msg
footer model =
    p [class "nav nav-item"] [Html.text model.url]

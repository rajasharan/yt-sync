module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Color exposing (..)
import Json.Decode exposing (..)

import Types exposing (..)

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

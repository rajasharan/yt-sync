module Views exposing (view)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import String exposing (..)
import List.Extra exposing (..)

import Types exposing (..)

view : Model -> Html Msg
view model =
    let
        --_ = Debug.log "view:model" model
        error_notification =
            if length model.err > 0 then
                "notification is-danger"
            else
                ""
        cards = List.map (\vid -> card vid) model.cue

    in
    div [class "container"]
      [ header model
      , Html.div [class error_notification] [Html.text model.err]
      , div [class "columns"]
          [ div [class "column is-10"]
              [ section [class "hero"]
                  [ div [class "hero-body"]
                      [ div [class "container"]
                          [ div [id "video-wrapper", class "video-wrapper", onClick TogglePlay]
                              [ div [id "player"] [] ]
                          ]
                      ]
                  , playbar model
                  ]
              ]
          , div [class "column is-2 video-list"]
              [ div [] cards ]
          ]
      ]

card : Video -> Html Msg
card video =
   div [class "card", onClick (SelectVideo video.index)]
      [ div [class "card-image"]
          [figure [class "image is-16by9"]
            [img [src <| "https://img.youtube.com/vi/"++ video.id ++"/mqdefault.jpg"][]]
          ] 
      --, div [class "card-content"]
          --[ div [class "media"]
              --[ div [class "media-content"]
                  --[ p [class "title is-5"] [text video.author]
                  ----, p [class "subtitle is-6"] [text "@johnsmith"]
                  --]
              --]
          --, div [class "content"]
              --[text video.title]
          --]
      ]

header : Model -> Html Msg
header model =
    p [class "control has-addons has-addons-centered nav nav-item"]
      [ input
          [ class "input is-large is-expanded"
          , type' "text"
          , placeholder "Search Youtube Videos"
          , onInput UrlInput
          , on "keypress" (Json.map Load keyCode)
          ] []
      , button [class "button is-info is-large", onClick (Load 13)] [Html.text "Youtube search"]
      ]

playbar : Model -> Html Msg
playbar model =
  p [class "control"]
    [ input [ type' "range"
            , class "input is-expanded hint--bottom hint--bounce"
            , HA.min "0"
            , HA.max <| toString model.total
            , step "1"
            , defaultValue "0"
            , HA.value <| toString model.seek
            , attribute "aria-label" (toString model.seek ++ " sec / " ++ toString model.total ++ " sec")
            , onInput SeekBar
            ] []
    ]

footer : Model -> Html Msg
footer model =
    p [class "nav nav-item"] [Html.text <| toString model.seek]

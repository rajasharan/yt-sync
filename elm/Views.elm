module Views exposing (view)

import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json exposing (..)
import String exposing (..)

import Types exposing (..)

view : Model -> Html Msg
view model =
    let
        --_ = Debug.log "view:model" model
        attrs =
            [ src <| "https://www.youtube.com/embed/"
                  ++ model.vId
                  ++ "?enablejsapi=1"
                  ++ "&controls=0"
                  ++ "&fs=1"
                  ++ "&showinfo=1"
            , id "iframe"
            ]

        error_notification =
            if length model.err > 0 then
                "notification is-danger"
            else
                ""
    in

    div [class "container"]
      [ header model
      , Html.div [class error_notification] [Html.text model.err]
      , section [class "hero"]
          [ div [class "hero-body"]
              [ div [class "container"]
                  [ div [id "video-wrapper", class "video-wrapper", onClick TogglePlay]
                      [ div [id "player"] [] ]
                  ]
              ]
          ]
        , playbar model
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
          , onInput UrlInput
          , on "keypress" (Json.map Load keyCode)
          ] []
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

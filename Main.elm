import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import List.Extra exposing (..)
import String exposing (..)
import Mouse exposing (..)

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

type alias Url = String
type alias Model = Url

type Msg = OnInput String
         | Click

init : (Model, Cmd Msg)
init = ("", Cmd.none)

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
        OnInput url -> Debug.log "url" (getVideoId url) ! []
        Click -> Debug.log "click" model ! []

subs : Model -> Sub Msg
subs model =
    Sub.batch []

view : Model -> Html Msg
view model =
    let
        attrs =
            [ src <| "https://www.youtube.com/embed/"
                  ++ model
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
                  [ div [class "video-wrapper", onClick Click]
                      [ iframe attrs [] ]
                  ]
              ]
          ]
      --, footer model
      ]

header : Html Msg
header =
    p [class "control has-addons has-addons-centered nav nav-item"]
      [ button [class "button is-info is-large", disabled True] [text "youtube link"]
      , input
          [ class "input is-large is-expanded"
          , type' "text"
          , placeholder "Enter youtube link"
          , onInput OnInput
          ] []
      ]

footer : Model -> Html Msg
footer model =
    p [class "nav nav-item"] [text model]

import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import List.Extra exposing (..)
import String exposing (..)
import Mouse exposing (..)
import Ports exposing (..)

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

type alias Url = String
type alias Model =
    { url : Url
    , err : String
    , server : String
    , play : Bool
    , total : Float
    }

type Msg = Load String
         | Click
         | Err String
         | Play Float
         | Pause Float
         | Seek Float
         | Total Float

init : (Model, Cmd Msg)
init = ( { url = ""
         , err = ""
         , server = ""
         , play = False
         , total = 0.0
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
        Err err -> { model | err = err ++ " Please reload!!!" } ! []
        Play time -> model ! []
        Pause time -> model ! []
        Seek time -> model ! []
        Total time -> { model | total = time } ! []

subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ errored Err
        , played Play
        , paused Pause
        , seeked Seek
        , totaled Total
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
          , onInput Load
          ] []
      ]

footer : Model -> Html Msg
footer model =
    p [class "nav nav-item"] [text model.url]

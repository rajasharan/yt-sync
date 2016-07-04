import String exposing (..)
import Navigation as App exposing (..)

import Types exposing (..)
import Views exposing (view)
import Update exposing (update)
import Subs exposing (subs)

main : Program Never
main =
    App.program
        (makeParser (\l -> l.hash))
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        , urlUpdate = urlUpdate
        }

init : String -> (Model, Cmd Msg)
init hash =
    ( { url = ""
    , err = ""
    , server = dropLeft 1 hash
    , play = False
    , total = 0.0
    , width = 1000
    , cursorWidth = 0.0
    }
    , Cmd.none
    )

urlUpdate : String -> Model -> (Model, Cmd Msg)
urlUpdate hash model = { model | server = dropLeft 1 hash } ! []


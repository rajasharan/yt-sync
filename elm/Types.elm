module Types exposing (..)

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
         | Error String
         | Play Float
         | Pause Float
         | Seek Float
         | Total Float


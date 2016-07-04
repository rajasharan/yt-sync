module Utils exposing (..)

import List exposing (..)
import List.Extra exposing (..)
import String exposing (..)

import Types exposing (..)

head' : Maybe String -> String
head' maybe =
    case maybe of
        Just str -> str
        Nothing -> ""

getVideoId : String -> String
getVideoId url =
    if contains "v=" url then
        head' ((getAt 1 <| split "v=" url) `Maybe.andThen` (\s -> getAt 0 (split "&" s)))
    else
        url

convertSecondsToWidth : Float -> Model -> Float
convertSecondsToWidth sec model =
    sec * (Basics.toFloat model.width) / model.total

convertWidthToSecods : Float -> Model -> Float
convertWidthToSecods pos model =
    pos * model.total / (Basics.toFloat model.width)

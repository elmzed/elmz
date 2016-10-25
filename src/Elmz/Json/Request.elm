module Elmz.Json.Request exposing (..)

import Elmz.Json.Encoder exposing (Encoder)
import Elmz.Json.Encoder as Encoder
import Elmz.Json.Decoder exposing (Decoder)
import Elmz.Json.Decoder as Decoder
import Http
import Maybe
import Result
import Task exposing (Task)
import Time

type alias Request a b =
  { encoder : a -> Out String
  , decoder : Decoder b }

type alias Out a = { verb : String, url : String, body : a }
type alias Host = String
type alias Path = String

type Status e = Inactive | Waiting | Failed e

post : Host -> Path -> Encoder a -> Decoder b -> Request a b
post host path e d =
  let out a = Out "POST" (host ++ "/" ++ path) (Encoder.render e a)
  in Request out d

contramap : (a0 -> a) -> Request a b -> Request a0 b
contramap f r = { r | encoder = r.encoder << f }

map : (b -> c) -> Request a b -> Request a c
map f r = { r | decoder = Decoder.map f r.decoder }

to : Request a b -> (b -> c) -> Request a c
to r f = map f r

sendPost : Request a b -> a -> Task Http.Error b
sendPost r a =
  let out = r.encoder a
  in Http.post r.decoder out.url (Http.string out.body)

--posts : Request a b -> Signal (Maybe a) -> Signal (Task Http.Error (Maybe b))
--posts r a =
--  let
--    f a = case a of
--      Nothing -> Task.succeed Nothing
--      Just a -> Task.map Just (sendPost r a)
--  in Signal.map f a

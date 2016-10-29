module Elmz.Set exposing (..)

import Elmz.Maybe
import Set exposing (..)

maximum : Set comparable -> Maybe comparable
maximum =
  foldr (Elmz.Maybe.combine max << Just) Nothing

minimum : Set comparable -> Maybe comparable
minimum =
  foldr (Elmz.Maybe.combine min << Just) Nothing

all : (comparable -> Bool) -> Set comparable -> Bool
all f =
  foldr ((&&) << f) True

any : (comparable -> Bool) -> Set comparable -> Bool
any f =
  foldr ((||) << f) False

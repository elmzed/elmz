module Elmz.Result exposing (..)

import Result

merge : Result a a -> a
merge r = case r of
  Result.Err a -> a
  Result.Ok a -> a

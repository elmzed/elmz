module Elmz.Void exposing (Void, absurd)

type Void = Void Void

absurd : Void -> a
absurd v = absurd v

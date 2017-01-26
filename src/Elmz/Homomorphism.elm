module Elmz.Homomorphism exposing (..)

type Homomorphism m n
    = Homomorphism (m -> n)


homomorphism : Homomorphism m n -> m -> n
homomorphism (Homomorphism f) =
    f

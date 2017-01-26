module Elmz.Semigroup exposing (..)

import Elmz.Homomorphism exposing (Homomorphism)
import Expect
import Fuzz exposing (Fuzzer)
import Test exposing (Test)


type Semigroup a
    = Semigroup (a -> a -> a)


append : Semigroup a -> a -> a -> a
append (Semigroup f) =
    f


fuzz_associativity : Semigroup a -> Fuzzer a -> Test
fuzz_associativity s fuzzer =
    Test.fuzz3
        fuzzer
        fuzzer
        fuzzer
        "append is associative: append s a (append s b c) = append s (append s a b) c"
        (\a b c ->
            Expect.equal (append s a (append s b c)) (append s (append s a b) c)
        )


fuzz_preserveAppend : Semigroup m -> Semigroup n -> Fuzzer m -> Homomorphism m n -> Test
fuzz_preserveAppend m n fuzzer f =
    Test.fuzz2
        fuzzer
        fuzzer
        "The homomorphism preserves append: homomorphism f (append m a b) = append n (homomorphism f a) (homomorphism f b)"
        (\a b ->
            Expect.equal
                (Elmz.Homomorphism.homomorphism f (append m a b))
                (append n (Elmz.Homomorphism.homomorphism f a) (Elmz.Homomorphism.homomorphism f b))
        )


tuple2 : Semigroup m -> Semigroup n -> Semigroup ( m, n )
tuple2 m n =
    Semigroup (\( m1, n1 ) ( m2, n2 ) -> ( append m m1 m2, append n n1 n2 ))


tuple3 : Semigroup m -> Semigroup n -> Semigroup o -> Semigroup ( m, n, o )
tuple3 m n o =
    Semigroup (\( m1, n1, o1 ) ( m2, n2, o2 ) -> ( append m m1 m2, append n n1 n2, append o o1 o2 ))


function : Semigroup m -> Semigroup (a -> m)
function m =
    Semigroup (\f1 f2 a -> append m (f1 a) (f2 a))


maybe : Semigroup a -> Semigroup (Maybe a)
maybe s =
    let
        go m1 m2 =
            case ( m1, m2 ) of
                ( Nothing, b ) ->
                    b

                ( a, Nothing ) ->
                    a

                ( Just a, Just b ) ->
                    Just (append s a b)
    in
        Semigroup go


list : Semigroup (List a)
list =
    Semigroup List.append

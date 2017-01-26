module Elmz.Monoid exposing (..)

import Elmz.Homomorphism exposing (Homomorphism)
import Elmz.Semigroup exposing (Semigroup)
import Expect
import Fuzz exposing (Fuzzer)
import Test exposing (Test)


type Monoid a
    = Monoid (Semigroup a) a


semigroup : Monoid a -> Semigroup a
semigroup (Monoid s _) =
    s


empty : Monoid a -> a
empty (Monoid _ e) =
    e


fuzz_leftIdentity : Monoid a -> Fuzzer a -> Test
fuzz_leftIdentity m f =
    Test.fuzz
        f
        "empty is a left identity: append m (empty m) a = a"
        (\a ->
            Expect.equal (append m (empty m) a) a
        )


fuzz_rightIdentity : Monoid a -> Fuzzer a -> Test
fuzz_rightIdentity m f =
    Test.fuzz
        f
        "empty is a right identity: append m a (empty m) = a"
        (\a ->
            Expect.equal (append m a (empty m)) a
        )


fuzz_preserveEmpty : Monoid m -> Monoid n -> Homomorphism m n -> Test
fuzz_preserveEmpty m n f =
    Test.test
        "The homomorphism preserves empty: homomorphism f (empty m) = empty n"
        (\_ ->
            Expect.equal (Elmz.Homomorphism.homomorphism f (empty m)) (empty n)
        )


append : Monoid a -> a -> a -> a
append =
    Elmz.Semigroup.append << semigroup


concat : Monoid a -> List a -> a
concat m =
    List.foldr (append m) (empty m)


hom : Monoid m -> (a -> m) -> List a -> m
hom m f =
    concat m << List.map f


tuple2 : Monoid m -> Monoid n -> Monoid ( m, n )
tuple2 m n =
    Monoid
        (Elmz.Semigroup.tuple2 (semigroup m) (semigroup n))
        ( empty m, empty n )


tuple3 : Monoid m -> Monoid n -> Monoid o -> Monoid ( m, n, o )
tuple3 m n o =
    Monoid
        (Elmz.Semigroup.tuple3 (semigroup m) (semigroup n) (semigroup o))
        ( empty m, empty n, empty o )


function : Monoid m -> Monoid (a -> m)
function m =
    Monoid
        (Elmz.Semigroup.function (semigroup m))
        (always (empty m))


maybe : Semigroup a -> Monoid (Maybe a)
maybe s =
    Monoid (Elmz.Semigroup.maybe s) Nothing


list : Monoid (List a)
list =
    Monoid Elmz.Semigroup.list []

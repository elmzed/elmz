module Elmz.Uniplate exposing (..)

import Elmz.Maybe
import Elmz.Tree.Binary exposing (Tree(..))


type Uniplate on
    = Uniplate (on -> ( Tree on, Tree on -> on ))


uniplate : Uniplate on -> on -> ( Tree on, Tree on -> on )
uniplate (Uniplate f) =
    f


descend : Uniplate on -> (on -> on) -> on -> on
descend u f on =
    let
        ( tree, from ) =
            uniplate u on
    in
        from (Elmz.Tree.Binary.map f tree)


transform : Uniplate on -> (on -> on) -> on -> on
transform u f on =
    let
        ( tree, from ) =
            uniplate u on
    in
        f (from (Elmz.Tree.Binary.map (transform u f) tree))


children : Uniplate on -> on -> List on
children u on =
    Elmz.Tree.Binary.toList (fst (uniplate u on))


universe : Uniplate on -> on -> List on
universe u on =
    let
        go t acc =
            case t of
                Zero ->
                    acc

                One on ->
                    on :: go (fst (uniplate u on)) acc

                Two t1 t2 ->
                    go t1 (go t2 acc)
    in
        go (One on) []


rewrite : Uniplate on -> (on -> Maybe on) -> on -> on
rewrite u f =
    let
        go on =
            Elmz.Maybe.maybe on (rewrite u f) (f on)
    in
        transform u go


para : Uniplate on -> (on -> List r -> r) -> on -> r
para u f on =
    f on (List.map (para u f) (children u on))


contexts : Uniplate on -> on -> List ( on, on -> on )
contexts u on =
    let
        go =
            List.concatMap
                (\( child, ctx ) ->
                    List.map
                        (\( y, context ) ->
                            ( y, ctx << context )
                        )
                        (contexts u child)
                )
    in
        ( on, identity ) :: go (holes u on)


holes : Uniplate on -> on -> List ( on, on -> on )
holes u x =
    let
        go t from =
            case t of
                Zero ->
                    []

                One i ->
                    [ ( i, from << One ) ]

                Two l r ->
                    go l (from << (flip Two r)) ++ go r (from << (Two l))
    in
        uncurry go (uniplate u x)


type alias Type from to =
    ( Tree to, Tree to -> from )


plate : from -> Type from to
plate from =
    ( Zero, \_ -> from )


plateSelf : to -> Type to to
plateSelf to =
    ( One to
    , \t ->
        case t of
            One t ->
                t

            _ ->
                to
    )


notTarget : item -> Type (item -> from) to -> Type from to
notTarget item ( t, f ) =
    ( t, \t -> f t item )


isTarget : to -> Type (to -> from) to -> Type from to
isTarget to ( t, f ) =
    ( Two t (One to)
    , \t ->
        case t of
            Two t (One to) ->
                f t to

            _ ->
                f t to
    )

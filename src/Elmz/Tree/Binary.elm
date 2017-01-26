module Elmz.Tree.Binary exposing (..)

import Elmz.Monoid exposing (Monoid)

type Tree a
    = Zero
    | One a
    | Two (Tree a) (Tree a)


map : (a -> b) -> Tree a -> Tree b
map f t =
    case t of
        Zero ->
            Zero

        One a ->
            One (f a)

        Two t1 t2 ->
            Two (map f t1) (map f t2)


foldMap : Monoid m -> (a -> m) -> Tree a -> m
foldMap m f t =
    case t of
        Zero ->
            Elmz.Monoid.empty m

        One a ->
            f a

        Two t1 t2 ->
            Elmz.Monoid.append m (foldMap m f t1) (foldMap m f t2)


toList : Tree a -> List a
toList =
    foldMap Elmz.Monoid.list (\x -> [ x ])

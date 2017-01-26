module Elmz.Biplate exposing (..)

import Elmz.Maybe
import Elmz.Tree.Binary exposing (Tree(..))
import Elmz.Uniplate exposing (Uniplate)


type Biplate from to
    = Biplate (Uniplate to) (from -> ( Tree to, Tree to -> from ))


biplate : Biplate from to -> from -> ( Tree to, Tree to -> from )
biplate (Biplate _ f) =
    f


uniplate : Biplate from to -> Uniplate to
uniplate (Biplate u _) =
    u


descend : Biplate from to -> (to -> to) -> from -> from
descend u f x =
    let
        ( tree, from ) =
            biplate u x
    in
        from (Elmz.Tree.Binary.map f tree)


transform : Biplate from to -> (to -> to) -> from -> from
transform u f x =
    let
        ( tree, from ) =
            biplate u x
    in
        from (Elmz.Tree.Binary.map (Elmz.Uniplate.transform (uniplate u) f) tree)


children : Biplate from to -> from -> List to
children u x =
    Elmz.Tree.Binary.toList (fst (biplate u x))


universe : Biplate from to -> from -> List to
universe u x =
    List.concatMap (Elmz.Uniplate.universe (uniplate u)) (children u x)


rewrite : Biplate from to -> (to -> Maybe to) -> from -> from
rewrite u f =
    let
        go x =
            Elmz.Maybe.maybe x (Elmz.Uniplate.rewrite (uniplate u) f) (f x)
    in
        transform u go


para : Biplate from -> (from -> List r -> r) -> from -> r
para =
    para

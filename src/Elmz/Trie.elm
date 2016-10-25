module Elmz.Trie exposing (..)

import List
import Maybe

type Trie k v = Trie (Maybe v) (List (k, Trie k v))

empty : Trie k v
empty = Trie Nothing []

isEmpty : Trie k v -> Bool
isEmpty t = case t of
  Trie Nothing [] -> True
  _ -> False

leaf : v -> Trie k v
leaf v = Trie (Just v) []

cons : k -> Trie k v -> Trie k v
cons hd t = Trie Nothing [(hd, t)]

set : v -> Trie k v -> Trie k v
set v (Trie _ cs) = Trie (Just v) cs

mergeDisjoint : Trie k v -> Trie k v -> Trie k v
mergeDisjoint (Trie v1 t1) (Trie v2 t2) =
  if Trie v2 t2 == empty then Trie v1 t1
  else if Trie v1 t1 == empty then Trie v2 t2
  else Trie (Maybe.oneOf [v1,v2]) (t1 ++ t2)

fromList : List (List k, v) -> Trie k v
fromList kvs = List.foldl (\(k,v) acc -> insert k v acc) empty kvs

insert : List k -> v -> Trie k v -> Trie k v
insert k v (Trie v0 children) = case k of
  [] -> Trie (Just v) children
  h :: t -> let (yes,no) = List.partition (\(k2,_) -> k2 == h) children
            in case yes of
                 [] -> Trie v0 ((h, insert t v empty) :: no)
                 (_,child) :: _ -> Trie v0 ((h, insert t v child) :: no)

lookup : List k -> Trie k v -> Maybe v
lookup k (Trie v children) = case k of
  [] -> v
  h :: t -> let f (k,v) = if k == h then Just v else Nothing
            in case List.filterMap f children of
                 child :: _ -> lookup t child
                 []     -> Nothing

deleteSubtree : List k -> Trie k v -> Trie k v
deleteSubtree k (Trie v children) = case k of
  [] -> empty
  h :: [] -> let f2 (k,child) = if k == h then Nothing else Just (k, child)
             in Trie v (List.filterMap f2 children)
  h :: t -> let f2 (k,child) = if k == h then (k, deleteSubtree t child) else (k, child)
            in Trie v (List.map f2 children)

delete : List k -> Trie k v -> Trie k v
delete k (Trie v children) = case k of
  [] -> Trie Nothing children
  h :: t -> let f2 (k,child) = if k == h then (k, delete t child) else (k, child)
            in Trie v (List.map f2 children)

contains : List k -> Trie k v -> Bool
contains k t = case lookup k t of
  Nothing -> False
  Just _ -> True

keys : Trie k v -> List (List k)
keys (Trie v cs) =
  let f (k,t) = List.map ((::) k) (keys t)
      addroot = case v of
        Nothing -> identity
        Just _ -> \tl -> [] :: tl
  in addroot (List.concatMap f cs)

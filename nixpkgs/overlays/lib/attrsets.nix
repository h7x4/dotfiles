self: super:
let
  inherit (super.lib.attrsets) listToAttrs nameValuePair;
  inherit (super.lib.lists) foldr;
in super.lib.attrsets // {
  # a -> [String] -> AttrSet{a}
  mapToAttrsWithConst = constant: items:
    listToAttrs (map (name: nameValuePair name constant) items);

  # [AttrSet] -> AttrSet
  concatAttrs = foldr (a: b: a // b) {};
}

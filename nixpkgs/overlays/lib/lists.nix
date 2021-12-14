self: super:
let 
  inherit (super.lib.trivial) const;
  inherit (super.lib.lists) range any all;
in super.lib.lists // {
  # a -> Int -> [a]
  repeat = item: times: map (const item) (range 1 times);

  # [Bool] -> Bool
  any' = any (boolean: boolean);

  # [Bool] -> Bool
  all' = all (boolean: boolean);
}

import algorithm, sequtils, math
import random, random.xorshift

iterator random_permutations(list: var seq[float], count: int): seq[float] =
  for i in 0..count:
    list.shuffle()
    yield list

proc goodness(binsizes: seq[float], bins: seq[seq[float]]): float =
  if len(binsizes) < len(bins):
    return -1.0
  var bins = bins & repeat(0.0, len(binsizes) - len(bins))
  result = 0.0
  for val in zip(binsizes, bins):
    let binsize = val.a
    let bin = val.b
    result += binsize - sum(bin)

proc generate_packings(binsizes: seq[float],
                       objects: seq[float],
                       tries=1000000): seq[seq[float]] =
  var binsizes = binsizes
  sort(binsizes, cmp[float])
  var objects = objects
  var best = (0.0, @[newSeq[float]()])

  for const_permutation in random_permutations(objects, tries):
    var next_layout = @[newSeq[float]()]
    var permutation = const_permutation

    while permutation.len != 0:
      if next_layout.len > binsizes.len:
        # it won't ever fit. just give up.
        break

      var extra_room = binsizes[next_layout.len - 1] - sum(next_layout[^1])
      if permutation[^1] <= extra_room:
        next_layout[^1].add(permutation.pop())
      else:
        next_layout.add(@[permutation.pop()])

    if permutation.len == 0 and goodness(binsizes, next_layout) > best[0]:
      best = (goodness(binsizes, next_layout), next_layout)
      echo best[1]

  return best[1]

var objects = mapIt(
  repeat(17.0, 6) & repeat(16.0, 4) & repeat(28.0, 6),
  it + 0.125)
var binsizes = repeat(72.0, 6)

discard generate_packings(binsizes, objects, tries=5000000)

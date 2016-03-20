from random import shuffle

def random_permutations(iterable, count):
    for _ in range(count):
        shuffle(iterable)
        yield list(iterable)

def goodness(binsizes, items):
    items = items + [0] * (len(binsizes) - len(items))
    result = 0
    for binsize, item in zip(binsizes, items):
        result += binsize - sum(item)
    return result

def generate_packings(binsizes, items, tries=100000):
    binsizes = sorted(binsizes)
    best = (0, [])
    for permutation in random_permutations(items, tries):
        next_layout = [[]]
        while permutation:
            if len(next_layout) > len(binsizes):
                # it won't ever fit. just give up.
                break

            extra_room = binsizes[len(next_layout) - 1] - sum(next_layout[-1])
            if permutation[-1] <= extra_room:
                # put it in the current bin!
                next_layout[-1].append(permutation.pop())
            else:
                # not enough extra room? move on to the next one.
                next_layout.append([permutation.pop()])
        else:
            if goodness(binsizes, next_layout) > best[0]:
                next_layout = [sorted(bin) for bin in next_layout]
                best = (goodness(binsizes, next_layout), next_layout)
                print(best)

    return best

def add_slack(lengths, slack):
    return [x + slack for x in lengths]

items = [17] * 5 + [16] * 4 + [28] * 6

print(generate_packings([72]*5, add_slack(items, 0.125)))

from collections import Counter, defaultdict
# agg operations

class Dice:
    def __init__(self, *outcomes):
        # list of lists
        self.outcomes = outcomes
        #self.outcomes = [[o] if isinstance(o, int) else o for o in outcomes]

    def count(self, target, under=False):
        op = (lambda x: x <= target) if under else (lambda x: x >= target)
        return Dice(len(filter(op, o)) for o in self.outcomes)
    def __rshift__(self, target):
        return self.count(target, under=False)
    def __lshift__(self, target):
        return self.count(target, under=True)
    __rrshift__ = __lshift__
    __rlshift__ = __rshift__
    def __str__(self):
        return str(self.outcomes)
    def __add__(self, other):
        """roll dice together in set"""
        if isinstance(other, int):
            return Dice(*(x + [other] for x in self.outcomes))
        if isinstance(other, Dice):
            return Dice(*(x + y for x in self.outcomes for y in other.outcomes))
        raise NotImplemented
    __radd__ = __add__
    def __mul__(self, other):
        if isinstance(other, int):
            x = self
            for _ in range(other - 1):
                # cursed
                x += self
            return x
        raise NotImplemented
    __rmul__ = __mul__
    def __matmul__(self, other):
        if isinstance(other, Dice):
            x = self
            for _ in range(other - 1):
                # cursed
                x += self
            return x
        raise NotImplemented
    __rmatmul__ = __matmul__


class NumberDice(defaultdict):
    def __missing__(self, key):
        return self.setdefault(key, list(range(1, key+1)))
d = NumberDice()
d['fate'] = [-1, 0, 1, -1, 0, 1]
print(d[10])
# max/min -> dis/advantage
# ifover / ifunder
3 * d[10] >> 5
# count of 

d6 = Dice(*range(1,7))

def counts(l):
    d = {}
    for x in l:
        d[x] = d.get(x, 0) + 1
    return d


print(~d6)
print(2 * d6)
print(~(3 * d6))

print("")
d66 = [int(str(x)+str(y)) for x in range(1,7) for y in range(1,7)]
print(d66)
print(counts(x % 7 for x in d66))
print([x for x in d66 if not x % 7])

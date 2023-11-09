class Dice:
    def __init__(self, *faces) -> None:
        self.outcomes = [[x] if isinstance(x, int) else x for x in faces]
    def __invert__(self):
        return list(map(sum, self.outcomes))
    def __str__(self):
        return str(self.outcomes)
    def __add__(self, other):
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


d0 = Dice()

d6 = Dice(*range(1,7))


print(~d6)
print(2 * d6)
print(~(3 * d6))

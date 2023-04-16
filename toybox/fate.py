
from itertools import product
from pprint import pprint as pp
import matplotlib.pyplot as plt
import numpy as np

"""
Show the difference in probability distibution between using fudge/fate dice or using 2d6.

fate dice are 6-sided dice where two faces show +, two show -, and two are blank.
A typical use case is throwing 4 fate dice and adding or subtracting one for each symbol shown.
This results in a range of results from -4 to 4

A common workaround when one doesn't have fate dice is to use 2 regular d6 dice of different colors.
One dice is 'negative' and is subtracted from the other, resulting in a range of results from -5 to 5.

The results show that fate dice are more likely to result in a roll in the range of -2 to 2
than the d6.
Playing with d6 may result in a more 'swingy' or luck based feel to the game as more extreme rolls are more common.
More extreme rolls are also possible since -5 and 5 are potential rolls
"""

# the face values of each dice type
fate = range(-1, 2)
d6 = range(1, 7)

# list possible outcomes from throwing each set of dice
f_outcomes = list(map(sum, product(fate,fate,fate,fate)))
#print(f_outcomes)
d_outcomes = list(map(lambda x: (x[0]-x[1]), product(d6, d6)))
#print(d_outcomes)

# count occurrences of each outcome and normalize
def counts(i):
    c = { x: 0.0 for x in set(i)}
    # total number of outcomes
    l = len(i)
    for x in i:
        c[x] += 1 / l
    return c

fc = counts(f_outcomes)
# pad missing outcomes from fate dice
fc = [0, *(fc[x] for x in range(-4, 5)), 0]
dc = counts(d_outcomes)
dc = [dc[x] for x in range(-5, 6)]


# create dual bar graph
x = np.arange(len(dc))
width = 0.35
labels = range(-5, 6)
fig, ax = plt.subplots()
bar1 = ax.bar(x -width/2, fc, width, label='fate')
bar2 = ax.bar(x +width/2, dc, width, label='d6')

ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()
plt.show()

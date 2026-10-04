# L06 - and in Python?

l = [1, 2, 3, 4, 5]

# map and filter have a dedicated syntax, the comprehension:
print([n * 10 for n in l if n % 2 == 0])

# which is exactly:
print(list(map(lambda n: n * 10, filter(lambda n: n % 2 == 0, l))))

# The fold, instead, lives in a separate module and has no syntax:
from functools import reduce
print(reduce(lambda acc, n: acc + n, l, 0))

# This is not a library detail. In Python 3 reduce was REMOVED from the
# built-in functions and moved into functools, by an explicit decision of
# Guido van Rossum, who considered it less readable than a for loop.
#
# And that is a defensible position, in a language where the for loop
# exists and is idiomatic. Notice, though, what it implies: map and filter
# made it into the syntax, the fold stayed out. Yet in class we have seen
# that map and filter are SPECIAL CASES of the fold.
#
# A language does not adopt the ideas of a paradigm in one block: it takes
# some of them, and which ones it takes says something about what it
# considers readable.

# Closures: they exist, and they work.
def times(k):
    return lambda n: n * k

double = times(2)
print(double(5))

# Beware of the classic trap, though, which does not exist in OCaml:
functions = []
for i in range(3):
    functions.append(lambda n: n + i)
print([f(10) for f in functions])     # [12, 12, 12], not [10, 11, 12]

# The lambda captures the VARIABLE i, not its value, and at the end of the
# loop i is 2 for all three. In OCaml this cannot happen: a binding does
# not change after being created, so capturing the binding and capturing
# the value are the same thing.

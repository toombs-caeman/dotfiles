#!/usr/bin/env python3
import pandas as pd

pd.set_option('display.max_rows', 500)
pd.set_option('display.max_columns', 500)
pd.set_option('display.width', 1000)

# column names
name = 'name'
birth = 'birth'
death = 'death'
action = 'action'
object = 'object' # careful of shadowing __builtin__.object
is_male = 'is_male'  # gender as a boolean (simplicity not accuracy)
language = 'language'
region = 'region'
tag = 'tag'
note = 'note'

def show(name, data):
    if len(data):
        if name:
            print(f'\n{name}:')
        print(data)

# construct dataframe from csv
df = (
    # these merge on the common 'name' column
    pd.read_csv(
        'data/person.csv',
        skipinitialspace=True,
        comment='#',
        dtype=str,
    )
    .drop_duplicates(name)
    # sort by birth and annotate with number
    .astype({is_male:float, birth:float})
    .sort_values(birth, ignore_index=True)
    .astype({is_male:bool})

)
df[birth] = df[birth].fillna(-1).astype(int)

print(df)

stats = df.count()
stats[is_male] = sum(df[is_male])
# list top 5 most popular languages, in order
language_counts = pd.Series(x for l in df[language] if isinstance(l, str) for x in l.split()).value_counts()
stats[language] = ', '.join(language_counts.index[:5])
show('stats', stats[[name, object, is_male, language]])

show('people missing birth date', df[df[birth] == -1][name])
show('count by region', df.groupby(region)[name].count())
show('count by tag', df.groupby(tag)[name].count())

bc = df.groupby(birth).count()
show('duplicate births', df[df[birth].isin(bc[bc[name] > 1].index)])

show('years with large gaps preceding', df[df[birth].diff() > 100][birth])

# exit()
import random
while True:
    tag = [name, action, object]
    ent = [ random.randint(00, 99) for _ in range(3) ]
    p, a, o = map(lambda x, y:df.iloc[x][y], ent, tag)
    print(f"{''.join(f'{x:02}' for x in ent)}: {p} {a} {o}")
    input()

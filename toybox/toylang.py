#!/usr/bin/env python
from dataclasses import dataclass
from typing import List
from pprint import pprint as pp
# https://blog.bruce-hill.com/packrat-parsing-from-scratch
# https://en.wikipedia.org/wiki/Parsing_expression_grammar
@dataclass
class match:
    text: str
    start: int
    end: int
    children: List['match']
    name: str | None

class Grammar:
    def __init__(self):
        self.rules = {}
        self.nodes = {}

    def node(self, node, *patterns):
        A = literal.wrap(*patterns) if len(patterns) == 1 else pe_seq(*patterns)
        self.nodes[node.__name__] = node
        self.rules[node.__name__] = A

    def parse(self, text):
        if (x := self.rules['start'](text, 0)) is None:
            print('no match')
            return x
        if x.start != 0 or x.end != len(text):
            print("didn't match whole input")
        return x

    def eval(self, tm: (match | str | None)):
        def eval_(m):
            nc = []
            for c in map(eval_, m.children):
                if isinstance(c, (tuple, list)):
                    nc.extend(c)
                else:
                    nc.append(c)
            m.children = nc

            if m.name is None:
                return m.children
            if m.name in self.impls.keys():
                return self.impls[m.name](m)
            print(f'name {m.name} has no implementation')

        if isinstance(tm, str):
            tm = self.parse(tm)
        return eval_(tm)
    def __call__(self, ref):
        return lambda text, i=0, _=None:self.rules[ref](text, i)

g = Grammar()

def cache(f):
    cache = {'':'', 0: None}
    def C(self,text, i=0, name=None):
        if (text != cache['']):
            cache.clear()
            cache[''] = text
        if i not in cache.keys():
            cache[i] = f(self, text, i, name)
        return cache[i]
    return C


class Node:
    def __call__(self, text, i=0, name=None):
        raise NotImplemented

class literal(Node):
    def __init__(self, pattern):
        self.pattern = pattern

    @staticmethod
    def wrap(v):
        if isinstance(v, str):
            return literal(v)
        return v

    @cache
    def __call__(self, text, i=0, name=None):
        if text.startswith(self.pattern, i):
            return match(text, i, i+len(self.pattern), [], name)


class pe_seq(Node):
    def __init__(self, *patterns):
        self.patterns = tuple(map(literal.wrap, patterns))

    @cache
    def __call__(self, text, i=0, name=None):
        start = i
        children = []
        for pattern in self.patterns:
            if (x := pattern(text, i)) is None:
                return None
            children.append(x)
            i = x.end
        return match(text, start, i, children, name)

class pe_one(Node):
    """one or more"""
    def __init__(self, *patterns):
        self.pattern = pe_seq(*patterns, pe_rep(*patterns))

    @cache
    def __call__(self, text, i=0, name=None):
        return self.pattern(text, i, name)

class pe_opt(Node):
    """zero or one"""
    def __init__(self, *patterns):
        self.pattern = pe_seq(*patterns)
    @cache
    def __call__(self, text, i=0, name=None):
        if (x := self.pattern(text, i, name)) is None:
            return match(text, i, i, [], name)
        return x

class pe_rep(Node):
    """zero or more"""
    def __init__(self, *patterns):
        self.A = pe_seq(*patterns)
    @cache
    def __call__(self, text, i=0, name=None):
        start = i
        children = []
        while x := self.A(text, i):
            children.append(x)
            i = x.end
        return match(text, start, i, children, name)


class pe_or(Node):
    def __init__(self, *patterns):
        self.patterns = tuple(map(literal.wrap, patterns))

    @cache
    def __call__(self, text, i=0, name=None):
        for pattern in self.patterns:
            if (x := pattern(text, i, name)) is not None:
                return x
        if not self.patterns:
            if i < len(text):
                return match(text, i, i+1, [], name)


class pe_not(Node):
    """negative lookahead"""
    def __init__(self, pattern):
        self.pattern = literal.wrap(pattern)

    @cache
    def __call__(self, text, i=0, name=None):
        if not self.pattern(text, i):
            return match(text,i,i,[],name)


class pe_and(Node):
    """lookahead"""
    def __init__(self, pattern):
        self.pattern = literal.wrap(pattern)

    @cache
    def __call__(self, text, i=0, name=None):
        if self.pattern(text, i):
            return match(text,i,i,[],name)

class pe_icc(Node):
    """inverted character class"""
    def __init__(self, cc):
        self.cc = cc
    def __call__(self, text, i=0, name=None):
        if i >= len(text) or text[i] not in self.cc:
            return match(text, i, i+1, [], name)

class pe_cc(Node):
    """character class"""
    def __init__(self, cc):
        self.cc = cc
    def __call__(self, text, i=0, name=None):
        if i < len(text) and text[i] in self.cc:
            return match(text, i, i+1, [], name)


class string(Node):
    pass

# # pe_term: https://en.wikipedia.org/wiki/Parsing_expression_grammar#Indirect_left_recursion
class pe_term(Node):
    pass

class pe_sym(Node):
    pass

class update_grammar(Node):
    pass

class start(Node):
    pass
class statement(Node):
    pass
class pe_statement(Node):
    pass
alpha = pe_cc('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_')
digit = pe_cc('0123456789')

# start :: statement? ('\n' statement?)*
g.node(start, pe_opt(g('statement')), pe_rep('\n', pe_opt(g('statement'))))
# statement :: parse / update_grammar
g.node(statement, pe_or(g('pe_statement'), g('update_grammar')))
# update_grammar :: 'update_grammar'
g.node(update_grammar, 'update_grammar')
# parse :: ' '* pe_sym ' '* '::' ' '* pe
g.node(pe_statement, g('pe_sym'), pe_rep(' '), '::', pe_rep(' '), g('pe'))
# pe_seq :: pe_term ' '+ pe
g.node(pe_seq, g('pe_term'), pe_one(' '), g('pe'))
# pe_opt :: pe_term '?'
g.node(pe_opt, g('pe_term'), '?')
# pe_rep :: pe_term '*'
g.node(pe_rep, g('pe_term'), '*')
# pe_one :: pe_term '+'
g.node(pe_one, g('pe_term'), '+')
# pe_or  :: pe_term ' '* '/' ' '* pe
g.node(pe_or, g('pe_term'), pe_rep(' '), '/', pe_rep(' '), g('pe'))
# pe_and :: '&' pe
g.node(pe_and, '&', g('pe'))
# pe_not :: '!' pe
g.node(pe_not, '!', g('pe'))
# pe_icc :: '[' ']'? [^]]* ']'
g.node(pe_icc, '[^', pe_opt(']'), pe_rep(pe_icc(']')), ']')
# pe_cc :: '[' ']'? [^]]* ']'
g.node(pe_cc, '[', pe_opt(']'), pe_rep(pe_icc(']')), ']')
# string :: ( '"' ([^"]/'\\"')* '"') / ("'" ([^']/"\\'")* "'")
g.node(string, pe_or(
    pe_seq('"', pe_rep(pe_or(pe_icc('"'), r'\"')), '"'),
    pe_seq("'", pe_rep(pe_or(pe_icc("'"), r"\'")), "'")
))
# pe_term :: '(' pe ')' / pe_sym / string / pe_cc
g.node(pe_term, pe_or(
    pe_seq('(',g('pe'),')'),g('pe_sym'),g('string'),g('pe_cc')
))
# pe_sym  :: [a-zA-Z_]+
g.node(pe_sym, pe_one(alpha))



peg="""
start :: statement? ('\n' statement?)*
statement :: parse / update_grammar
update_grammar :: 'update_grammar'
parse :: ' '* pe_sym ' '* '::' ' '* pe
pe      :: pe_or/pe_seq/pe_and/pe_not/pe_opt/pe_rep/pe_one/pe_term
pe_or  :: pe_term ' '* '/' ' '* pe
pe_seq :: pe_term ' '+ pe
pe_and :: '&' pe
pe_not :: '!' pe
pe_opt :: pe_term '?'
pe_rep :: pe_term '*'
pe_one :: pe_term '+'
pe_term :: '(' pe ')' / pe_sym / string / pe_cc
pe_sym  :: [a-zA-Z_]+
string :: ( '"' ([^"]/'\\"')* '"') / ("'" ([^']/"\\'")* "'")
pe_cc :: '[' '^'? ']'? [^]]* ']'
"""

peg="""
update_grammar
this :: that*
that :: he / she
update_grammar
"""
peg = """
Expr    :: Sum
Sum     :: Product (('+' / '-') Product)*
Product :: Power (('*' / '/') Power)*
Power   :: Value ('^' Power)?
Value   :: [0-9]+ / '(' Expr ')'
"""
print(repr(g.parse(peg)))
#pp(g.parse(peg).arr())
exit()
g = Grammar()
g.rule('start',    g('expr'))
g.rule('expr',    g('sum'))
g.rule('sum',     pe_seq(g('product'), pe_rep(pe_or(*'+-'), g('product'))))
g.rule('product', pe_seq(g('power'), pe_rep(pe_or(*'*/'), g('power'))))
g.rule('power',   pe_seq(g('value'), pe_opt('^', g('power'))))
g.rule('value',   pe_or(g('int'), pe_seq('(', g('expr'), ')')))
g.rule('int',     pe_one(digit))

@g.impl('product')
def product(m):
    if len(m.children) == 1:
        return m.children[0]
    return {'*':lambda x,y:x*y, '/':lambda x,y:x/y}[m.children[1]](m.children[0], m.children[2])

@g.impl('sum')
def sum(m):
    if len(m.children) == 1:
        return m.children[0]
    return {'+':lambda x,y:x+y, '-':lambda x,y:x-y}[m.children[1]](m.children[0], m.children[2])

g.impl('power',lambda m: m.children[0] if len(m.children) == 1 else pow(m.children[0], m.children[2]))
g.impl('value', lambda m: m.children[len(m.children) != 1])
g.impl('int', lambda m:int(m.text[m.start:m.end]))
g.impl('digit', lambda m:m.text[m.start:m.end])

#print(g.eval('67+8*(7-3)'))

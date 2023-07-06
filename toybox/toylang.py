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
        def start(text: str, i:int = 0) -> match | None:
            print('must define starting rule')
        self.rules = { 'start': start, }
        self.impls = {
                'literal': lambda m:m.text[m.start:m.end],
                None: lambda m:m.children,
        }
        self.nodes = {}

    def rule(self, truename, *patterns):
        A = l(*patterns) if len(patterns) == 1 else pe_seq(*patterns)
        self.rules[truename] = lambda text, i=0, _=None:A(text, i, truename)
        self.rules[truename].__name__ = truename

    def node(self, *patterns):
        A = l(*patterns) if len(patterns) == 1 else pe_seq(*patterns)
        def nd(n):
            self.nodes[n.__name__] = n
            self.rules[n.__name__] = A
            return n
        return nd

    def impl(self, name, f=None):
        if f is None:
            return lambda fn:self.impl(name, fn)
        self.impls[name] = f
        return f
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
    def C(text, i=0, name=None):
        if (text != cache['']):
            cache.clear()
            cache[''] = text
        if i not in cache.keys():
            cache[i] = f(text, i, name)
        return cache[i]
    return C

def l(pattern):
    if isinstance(pattern, str):
        @cache
        def literal(text,i=0, name=None):
            if text.startswith(pattern, i):
                return match(text, i, i+len(pattern), [], name or 'literal')
        return literal
    return pattern

class Node:
    pass

#@g.node(g('pe_term'), pe_rep(' '), '/', pe_rep(' '), g('pe'))
#class pe_or(Node):
#    def __init__(self, *patterns):
#        if patterns:
#            @cache
#            def o(text, i=0, name=None):
#                for pattern in map(l, patterns):
#                    if (x := pattern(text, i, name)) is not None:
#                        return x
#            self.parse = o
#        else:
#            @cache
#            def O(text, i=0, name=None):
#                if i < len(text):
#                    return match(text, i, i+1, [], name)
#            self.parse = O


def pe_or(*patterns):
    if patterns:
        @cache
        def o(text, i=0, name=None):
            for pattern in map(l, patterns):
                if (x := pattern(text, i, name)) is not None:
                    return x
        return o
    @cache
    def O(text, i=0, name=None):
        if i < len(text):
            return match(text, i, i+1, [], name)
    return O


def pe_seq(*patterns):
    @cache
    def A(text, i=0, name=None):
        start = i
        children = []
        for pattern in map(l, patterns):
            if (x := pattern(text, i)) is None:
                return None
            children.append(x)
            i = x.end
        m = match(text, start, i, children, name)
        #print(f'{name}: {text[start:i]!r}')

        return m
    return A

def pe_rep(*patterns):
    """zero or more"""
    A = pe_seq(*patterns)
    @cache
    def Z(text, i=0, name=None):
        start = i
        children = []
        while x := A(text, i):
            children.append(x)
            i = x.end
        return match(text, start, i, children, name)
    return Z

def pe_opt(*patterns):
    """zero or one"""
    A = pe_seq(*patterns)
    @cache
    def Z1(text, i=0, name=None):
        if (x := A(text, i, name)) is None:
            return match(text, i, i, [], name)
        return x
    return Z1

def pe_cc(cc):
    """character class"""
    def CC(text, i=0, name=None):
        if i < len(text) and text[i] in cc:
            return match(text, i, i+1, [], name)
    return CC

def pe_icc(cc):
    """inverted character class"""
    def ICC(text, i=0, name=None):
        if i >= len(text) or text[i] not in cc:
            return match(text, i, i+1, [], name)
    return ICC


def pe_one(*patterns):
    """one or more"""
    return pe_seq(*patterns, pe_rep(*patterns))

def pe_not(pattern):
    """negative lookahead"""
    @cache
    def N(text, i=0, name=None):
        if not l(pattern)(text, i):
            return match(text,i,i,[],name)
    return N

def pe_and(pattern):
    """lookahead"""
    pattern = l(pattern)
    @cache
    def N(text, i=0, name=None):
        if pattern(text, i):
            return match(text,i,i,[],name)
    return N

digit = pe_or(*'0123456789')
alpha = pe_or(*map(chr,(*range(ord('a'),ord('z')+1),*range(ord('A'),ord('Z')+1))))

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

g = Grammar()
# start :: statement? ('\n' statement?)*
g.rule('start', pe_opt(g('statement')), pe_rep('\n', pe_opt(g('statement'))))
# statement :: parse / update_grammar
g.rule('statement', pe_or(g('parse'), g('update_grammar')))
# update_grammar :: 'update_grammar'
g.rule('update_grammar', 'update_grammar')
# parse :: ' '* pe_sym ' '* '::' ' '* pe
g.rule('parse',pe_rep(' '),g('pe_sym'),pe_rep(' '),'::',pe_rep(' '),g('pe'))
# pe      :: pe_or / pe_seq / pe_look / pe_count / pe_term
g.rule('pe',pe_or(*map(g,'pe_or/pe_seq/pe_look/pe_count/pe_term'.split('/'))))
# pe_or  :: pe_term ' '* '/' ' '* pe
g.rule('pe_or', g('pe_term'), pe_rep(' '), '/', pe_rep(' '), g('pe'))
# pe_seq :: pe_term ' '+ pe
g.rule('pe_seq', g('pe_term'), pe_one(' '), g('pe'))
# pe_look :: [&!] pe
g.rule('pe_look', pe_cc('&!'), g('pe'))
# pe_count :: pe_term [?*+]
g.rule('pe_count', g('pe_term'), pe_cc('?*+'))
# # pe_term: https://en.wikipedia.org/wiki/Parsing_expression_grammar#Indirect_left_recursion
# pe_term :: '(' pe ')' / pe_sym / string / pe_cc
g.rule('pe_term',pe_or(pe_seq('(',g('pe'),')'),g('pe_sym'),g('string'),g('pe_cc')))
# pe_sym  :: [a-zA-Z_]+
alpha = ''.join(map(
    chr,
    (*range(ord('a'),ord('z')+1),*range(ord('A'),ord('Z')+1))
)) + '_'
g.rule('pe_sym', pe_one(pe_cc(alpha)))
# string :: ( '"' ([^"]/'\\"')* '"') / ("'" ([^']/"\\'")* "'")
g.rule('string', pe_or(
    pe_seq('"', pe_rep(pe_or(pe_icc('"'), r'\"')), '"'),
    pe_seq("'", pe_rep(pe_or(pe_icc("'"), r"\'")), "'")
))
# pe_cc :: '[' '^'? ']'? [^]]* ']'
g.rule('pe_cc', '[', pe_opt('^'), pe_opt(']'), pe_rep(pe_icc(']')), ']')


peg="""
start :: statement? ('\n' statement?)*
statement :: parse / update_grammar
update_grammar :: 'update_grammar'
parse :: ' '* pe_sym ' '* '::' ' '* pe
pe      :: pe_or / pe_seq / pe_look / pe_count / pe_term
pe_or  :: pe_term ' '* '/' ' '* pe
pe_seq :: pe_term ' '+ pe
pe_look :: [&!] pe
pe_count :: pe_term [?*+]
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

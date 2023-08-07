#!/usr/bin/env python
from dataclasses import dataclass
from pprint import pprint as pp
# https://blog.bruce-hill.com/packrat-parsing-from-scratch
# https://en.wikipedia.org/wiki/Parsing_expression_grammar
@dataclass
class debug_info:
    # bound the text which created this object
    file: str
    # the line #
    line_start: int
    line_end: int
    # the character # relative to the file
    c_start: int
    c_end: int
    # the character # relative to the line
    lc_start: int
    lc_end: int
    def __str__(self):
        return 'no debug'

@dataclass
class match:
    start: int
    stop: int
    inner: list | str = ''
    is_arg: bool = False
    ast_name: str|None = None
    def ast(self, _include=False):
        _include = _include or self.is_arg and not self.ast_name
        args = []
        match self.inner:
            case str():
                if _include:
                    args.append(self.inner)
            case list():
                for m in self.inner:
                    if m.ast_name:
                        args.append(m.ast(_include))
                    else:
                        args.extend(m.ast(_include))

        if self.ast_name:
            return [self.ast_name, *args]
        return args

class string(str):
    def __call__(self, t, i):
        if t.startswith(self, i):
            return match(i, i+len(self), self)

class Dot:
    """match any one character"""
    def __call__(self, t, i=0):
        if len(t) > i:
            return match(i,i+1,t[i])
    def __repr__(self):
        return '.'
dot = Dot()

class s:
    """ Sequence: e1 e2 """
    def __init__(self, *p):
        self.p = tuple(pegify(x) for x in p)
        cache = {'':'', 0:match(0,0,'')}
        f = self.__call__
        def ccall(t, i=0):
            if (t!=cache['']):
                cache.clear()
                cache[''] = t
            if i not in cache:
                cache[i] = f(t,i)
            return cache[i]
        self.__call__ = ccall
    def __iter__(self):
        return iter(self.p)
    def __len__(self):
        return len(self.p)
    def __call__(self, t, i=0):
        s,c = i, []
        for p in self:
            if (x := p(t, i)) is None:
                return None
            if x.stop > x.start:
                c.append(x)
            i = x.stop
        return match(s,i,c)
    def __repr__(self):
        match len(self):
            case 0:
                return 'ε'
            case 1:
                return repr(self.p[0])
            case _:
                return '(' + ' '.join(repr(x) for x in self) + ')'

class o(s):
    """ Ordered choice: e1 / e2 """
    def __call__(self, t, i=0):
        return next((x for p in self if (x:=p(t,i))), None)
    def __repr__(self):
        if len(self) > 1:
            return '(' + ' / '.join(repr(x) for x in self) + ')'
        return repr(self.p)

class z(s):
    """ Zero-or-more: e* """
    def __call__(self, t, i=0):
        s,c = i, []
        while (x:=super().__call__(t,i)):
            c.extend(x.inner)
            i = x.stop
        return match(s,i,c)
    def __repr__(self):
        return super().__repr__() + '*'

class p(z):
    """ One-or-more: e+ """
    def __call__(self, t, i=0):
        if (x:=s.__call__(self, t, i)) is None:
            return None
        if (y:=z.__call__(self, t, x.stop)):
            x = match(i,y.stop,x.inner+y.inner)
        return x
    def __repr__(self):
        return super(z, self).__repr__() + '+'

class q(s):
    """ Optional: e? """
    def __call__(self, t, i=0):
        return x if (x:=super().__call__(t,i)) else match(i,i)
    def __repr__(self):
        return super().__repr__() + '?'

class a(s):
    """ And-predicate: &e """
    def __call__(self, t, i=0):
        if (super().__call__(t,i)):
            return match(i,i)
    def __repr__(self):
        return '&' + super().__repr__()

class n(s):
    """ Not-predicate: !e """
    def __call__(self, t, i=0):
        if super().__call__(t,i) is None:
            return match(i,i)
    def __repr__(self):
        return '!' + super().__repr__()

class c(o):
    """ Character Class: [0-9X]"""
    def __init__(self, cls):
        cls, p, self._repr = list(cls), [], f'[{cls}]'
        while cls:
            if len(cls) > 2 and cls[1] == '-':
                start, _, stop, *cls = cls
                p.extend(map(chr, range(ord(start), ord(stop) + 1)))
            else:
                p.append(cls.pop(0))
        super().__init__(*p)
    def __repr__(self):
        return self._repr


class is_arg:
    """argument: %e"""
    def __init__(self, *p):
        self.p = pegify(p[0]) if len(p) == 1 else s(*p)
    def __call__(self, t, i=0):
        if (m:=self.p(t,i)):
            m.is_arg = True
        return m
    def __repr__(self):
        return '%' + repr(self.p)
class has_ast(is_arg):
    def __init__(self, name, *p):
        super().__init__(*p)
        self.name = name
    def __call__(self, t, i=0):
        if (m:=self.p(t,i)):
            m.ast_name = m.ast_name or self.name
        return m


def pegify(v):
    T = { str:string, tuple:lambda x:s(*x), list:lambda x:o(*x)}
    return t(v) if (t:=T.get(type(v),None)) else v

class Grammar(dict):
    """ a grammar """
    def __repr__(self):
        return '\n'.join(f'{k} <- {v!r}' for k,v in self.items())
    def __call__(self, t, i=0):
        return self.resolve('main')(t,i)
    def __setitem__(self, k:str, v) -> None:
        if k.startswith('%'):
            v = has_ast(k.removeprefix('%'),v)
        return super().__setitem__(k.removeprefix('%'), pegify(v))
    def resolve(self, name):
        return super().__getitem__(name)
    def __getitem__(self, name):
        return Grammar.Ref(self, name)
    class Ref:
        def __init__(self, grammar, name):
            self.grammar = grammar
            self.name = name
        def resolve(self):
            x = self.grammar.resolve(self.name.removeprefix('%'))
            if self.name.startswith('%'):
                x = is_arg(x)
            return x
        def __call__(self, t, i=0):
            return self.resolve()(t,i)
        def __repr__(self):
            return self.name

g = Grammar()
"""
Grammar <- Expr
Expr <- Add/ Sub/ Mul/ Div/ Pow/ Val
Sum  <- Add / Sub
Add  <- %Product '+' %Product
Sub  <- %Product '-' %Product
Product <- Mul / Div / Val
Mul  <- %Pow '*' %Pow
Div  <- %Val '/' %Pow
Pow  <- %Val ('^' %Pow)?
Val  <- Number / '(' Expr ')'

Expr <- Sum
Sum  <- Product (('+' / '-') Product)*
Prod <- Power (('*' / '/') Power)*
Pow  <- Value ('^' Power)?
Val  <- Num / '(' Expr ')'
Num<- %([0-9]+ ('.' [0-9]+)?)
"""
g['main']   = g['Expr'], g['EndOfFile']
# priority low to high
priority = [
        [g['Add'], g['Sub']],
        [g['Mul'], g['Div']],
        g['Pow'],
        g['Group'],
        g['Num']]
g['%Expr']  = priority[0:]
g['%Add']  = priority[1:], g['PLUS'],  priority[0:]
g['%Sub']  = priority[1:], g['MINUS'], priority[0:]
g['%Mul']  = priority[2:], g['STAR'],  priority[1:]
g['%Div']  = priority[2:], g['SLASH'], priority[1:]
g['%Pow']  = priority[3:], g['CARAT'], priority[2:]
g['Group'] = g['OPEN'], g['Expr'], g['CLOSE']
g['%Num']  = is_arg(q('-'), p(c('0-9')), q('.',c('0-9'))), g['Spacing']
g['STAR']  = '*', g['Spacing']
g['PLUS']  = '+', g['Spacing']
g['CARAT'] = '^', g['Spacing']
g['MINUS'] = '-', g['Spacing']
g['SLASH'] = '/', g['Spacing']
g['OPEN']  = '(', g['Spacing']
g['CLOSE'] = ')', g['Spacing']
g['Spacing'] = z(' ')
g['EndOfFile'] = n(dot)
#print(repr(g))
#tree = g('1.2*34+5')
#tree = g['Mul']('1^2.3*4')
t = '1.2+3*4^4-5*6'
#t = '1.2+3*4-5'
tree = g(t)
if tree is None:
    print('no match')
else:
    pp(t)
    pp(tree.ast())


peg=r"""
# from https://bford.info/pub/lang/peg.pdf
# Hierarchical syntax
Grammar <- Spacing Definition+ EndOfFile
Definition <- Identifier LEFTARROW Expression
Expression <- Sequence (SLASH Sequence)*
Sequence <- Prefix*
Prefix <- (ARG / AND / NOT)? Suffix
Suffix <- Primary (QUESTION / STAR / PLUS)?
Primary <- Identifier !LEFTARROW / OPEN Expression CLOSE / Literal / Class / DOT
# Lexical syntax
Identifier <- IdentStart IdentCont* Spacing
IdentStart <- [a-zA-Z_]
IdentCont <- IdentStart / [0-9]
Literal <- ['] (!['] Char)* ['] Spacing
/ ["] (!["] Char)* ["] Spacing
Class <- '[' (!']' Range)* ']' Spacing
Range <- Char '-' Char / Char
Char <- '\\' [nrt'"\[\]\\]
/ '\\' [0-2][0-7][0-7]
/ '\\' [0-7][0-7]?
/ !'\\' .
LEFTARROW <- '<-' Spacing
SLASH <- '/' Spacing
ARG <- '%' Spacing
AND <- '&' Spacing
NOT <- '!' Spacing
QUESTION <- '?' Spacing
STAR <- '*' Spacing
PLUS <- '+' Spacing
OPEN <- '(' Spacing
CLOSE <- ')' Spacing
DOT <- '.' Spacing
Spacing <- (Space / Comment)*
Comment <- '#' (!EndOfLine .)* EndOfLine
Space <- ' ' / '\t' / EndOfLine
EndOfLine <- '\r\n' / '\n' / '\r'
EndOfFile <- !.
# TODO 'priority' construct
"""
g = Grammar()
g['%main'] = g['Spacing'], p(is_arg(g['Definition'])), g['EndOfFile']
g['%Definition'] = g['%Identifier'], g['LEFTARROW'], g['%Expression']
priority = [
        g['Choice'],
        g['Sequence'],
        [g['ZeroOrOne'], g['ZeroOrMore'], g['OneOrMore']],
        [g['Lookahead'], g['NotLookahead'], g['Argument']],
        g['Primary']]
g['Expression']  = priority
g['%Choice']     = priority[1:], p(g['SLASH'], priority[1:])
g['%Sequence']   = priority[2:], p(priority[2:])
g['%ZeroOrOne']  = priority[3:], g['QUESTION']
g['%ZeroOrMore'] = priority[3:], g['STAR']
g['%OneOrMore']  = priority[3:], g['PLUS']
g['%Lookahead']    = g['AND'], priority[4:]
g['%NotLookahead'] = g['NOT'], priority[4:]
g['%Argument']     = g['ARG'], priority[4:]
g['Primary'] = [
        (g['OPEN'], g['%Expression'], g['CLOSE']),
        (g['%Identifier'], n(g['LEFTARROW'])),
        g['%Literal'],
        g['%Class'],
        g['%DOT']]
# Lexical syntax
g['%Identifier'] = is_arg(g['IdentStart'], z(g['IdentCont'])), g['Spacing']
g['IdentStart'] = is_arg(c('a-zA-Z_'))
g['IdentCont'] = is_arg([g['IdentStart'], c('0-9')])
i, ii = c("'"), c('"')
g['%Literal'] = [(i, z(n(i),  g['%Char']), i,  g['Spacing']),
                (ii, z(n(ii), g['%Char']), ii, g['Spacing'])]
g['%Class'] = '[', z(n(']'), [g['%Range'],g['%Char']]),']', g['Spacing']
g['%Range'] = g['%Char'], '-', g['%Char']
bond = c('0-7')
g['Char'] = is_arg([('\\', c("nrt'\"[]\\")),
             ('\\', c('0-2'), bond, bond),
             ('\\', bond, q(bond)),
             (n('\\'), dot)])
g['LEFTARROW']  ='<-', g['Spacing']
g['SLASH']      = '/', g['Spacing']
g['ARG']        = '%', g['Spacing']
g['AND']        = '&', g['Spacing']
g['NOT']        = '!', g['Spacing']
g['QUESTION']   = '?', g['Spacing']
g['STAR']       = '*', g['Spacing']
g['PLUS']       = '+', g['Spacing']
g['OPEN']       = '(', g['Spacing']
g['CLOSE']      = ')', g['Spacing']
g['%DOT']       = '.', g['Spacing']
g['Spacing'] = z([g['Space'], g['Comment']])
g['Comment'] = '#', z(n(g['EndOfLine']), dot), g['EndOfLine']
g['Space'] = [' ', '\t', g['EndOfLine']]
g['EndOfLine'] = ['\r\n', '\n', '\r']
g['EndOfFile'] = n(dot)
#print(repr(g))
#print(repr(g) == peg)
tree = g(peg)
#pp(tree.ast())
#pp(g['Expression']('hanky\n').ast())
#print(peg[tree.start:tree.stop])
class Interpreter(Grammar):
    def __call__(self, ast):
        match ast:
            case list():
                return self.__getattribute__(ast[0])(*ast[1:])
            case _:
                return ast
    def main(self, *expr):
        for e in expr:
            self(e)
    def Definition(self, i, a):
        self[''.join(i[1:])] = self(a)
    def Choice(self, *a):
        return o(*(self(x) for x in a))
    def Sequence(self, *a):
        return s(*(self(x) for x in a))
    def ZeroOrOne(self, *a):
        return q(*(self(x) for x in a))
    def ZeroOrMore(self, *a):
        return z(*(self(x) for x in a))
    def OneOrMore(self, *a):
        return p(*(self(x) for x in a))
    def Lookahead(self, *x):
        return a(*(self(v) for v in x))
    def NotLookahead(self, *a):
        return n(*a)
    def Argument(self, a):
        return is_arg(self(a))
    def Identifier(self, *a:str):
        return self[''.join(a)]
    def Literal(self, *c:str):
        return string(''.join(c))
    def Class(self, *x):
        return c(''.join(self(c) for c in x))
    def Range(self, start:str, stop:str):
        return ''.join(chr(x) for x in range(ord(start), ord(stop)+1))
    def DOT(self, *_):
        return dot
i = Interpreter()
A = g['Class']('[0-8]').ast()
i(tree.ast())
#pp(i)
pp(tree.ast())
import json
with open('dream-init.json') as f:
    i(f.read())
#with open('dream-init.json', 'w') as f:
    #json.dump(tree.ast(), f)

#!/usr/bin/env python
from dataclasses import dataclass
from typing import List
from pprint import pprint as pp
# https://blog.bruce-hill.com/packrat-parsing-from-scratch
# https://en.wikipedia.org/wiki/Parsing_expression_grammar
s = 'Sequence'
c = 'Choice'
z = 'ZeroOrMore'
p = 'OneOrMore'
q = 'ZeroOrOne'
a = 'AndPredicate'
n = 'NotPredicate'
cls = 'CharacterClass'
l = 'Literal'
d = 'AnyCharacter'
m = 'main'
D = 'Definition'
i = 'Identifier'
A = 'Ast'
S = 'Spacing'
grammar=r"""
# from https://bford.info/pub/lang/peg.pdf
# Hierarchical syntax
%main <- Spacing %Definition+ EndOfFile
%Definition <- %Identifier LEFTARROW %Expression
# priority is encoded here
Expression <- Choice /
    Sequence /
    (ZeroOrOne / ZeroOrMore / OneOrMore) /
    (Lookahead / NotLookahead / Argument) /
    Identifier !LEFTARROW /
    OPEN Expression CLOSE /
    Literal /
    Class /
    DOT
%Choice   <- Expression~1 (SLASH Expression~1)+
%Sequence <- Expression~2 Expression~2+
%ZeroOrOne  <- Expression~3 IBANG
%ZeroOrMore <- Expression~3 STAR
%OneOrMore  <- Expression~3 PLUS
%Lookahead    <- AMP  Expression~4
%NotLookahead <- BANG Expression~4
%Argument     <- CENT Expression~4
%Identifier <- %[a-zA-Z_] %[a-zA-Z_0-9]* Spacing
%Literal <- ['] (!['] Char)* ['] Spacing / ["] (!["] Char)* ["] Spacing
%Class <- '[' %(!']' (Range/Char))* ']' Spacing
%Range <- %Char '-' %Char
Char <- %('\\' [nrt'"\[\]\\]
    / '\\' [0-2][0-7][0-7]
    / '\\' [0-7][0-7]?
    / !'\\' .)
LEFTARROW <- '<-' Spacing
SLASH <- '/' Spacing
CENT <- '%' Spacing
AMP <- '&' Spacing
BANG <- '!' Spacing
IBANG <- '?' Spacing
STAR <- '*' Spacing
PLUS <- '+' Spacing
OPEN <- '(' Spacing
CLOSE <- ')' Spacing
%DOT <- '.' Spacing
Spacing <- (Space / Comment)*
Comment <- '#' (!EndOfLine .)* EndOfLine
Space <- ' ' / '\t' / EndOfLine
EndOfLine <- '\r\n' / '\n' / '\r'
EndOfFile <- !.
"""
priority = [[i,c],[i,s],[c,[i,q],[i,z],[i,p]],[c,[i,a],[i,n],[i,A]]]
toy_ns = {
    m: [[i, S],[p, [A, [i, D]]]],
    #D:[A,[i,
}

# parser
#   ast form
#   string form
# match object
#   ast form

@dataclass
class peg(list):
    is_arg: bool = False
    has_ast: bool = False




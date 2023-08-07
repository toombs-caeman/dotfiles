#!/usr/bin/env python
from dataclasses import dataclass
from abc import ABC, abstractmethod
from pprint import pprint as pp
# core PEG constructs

# namespace object
"""
a match is
* int: a single character
* slice: a literal string
* list: 


program state is always serializable to json/bson.
keys:
    * "main": the current tree to evaluate
    * "global": the global namespace
"""

# src -> ast
# ast -> src
class match:
    def __init__(self, start, stop, *inner, ast_name = None):
        self.start = start
        self.stop = stop
        self.inner = inner
        self.ast_name = ast_name

class Node:
    def __init__(self, *data, is_arg = False, ast_name = None):
        self.data = data
        self.is_arg = is_arg
        self.ast_name = ast_name
        self.cache = {}
        self.cache_text = ''
    def __call__(self, t, i, *, keep=False):
        keep = keep or self.is_arg and not self.ast_name
        if self.cache_text != t:
            self.cache.clear()
            self.cache_text = t
        if i not in self.cache:
            self.cache[i] = self.__parse__(t, i, keep = keep)
            if self.cache[i]:
                self.cache[i].ast_name = self.ast_name
        return self.cache[i]
    @abstractmethod
    def __parse__(self, t, i, *, keep=False) -> match | None:
        pass

class Literal(Node):
    def __parse__(self, t, i, *, keep=False):
        s = self.data[0]
        if t.startswith(s, i):
            if keep:
                return match(i, i + len(s), s)
            return match(i, i + len(s))

class Sequence(Node):
    def __parse__(self, t, i, *, keep=False):
        start,data = i, []
        for p in self.data:
            if (x := p(t, i)) is None:
                return None
            if keep:
                data.append(x)
            i = x.stop
        return match(start, i, *data)

class Choice(Node):
    def __parse__(self, t, i, *, keep=False):
        return next((x for p in self.data if (x:=p(t,i))), None)

class Dot(Node):
    def __parse__(self, t, i, *, keep=False):
        if len(t) > i:
            if keep:
                return match(i, i+1, t[i])
            return match(i, i+1)


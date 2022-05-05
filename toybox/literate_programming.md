#!/usr/bin/env mdsh
# Markdown Shell (mdsh)
can we make a 'literate' bash script

* each header becomes a function. functions are called in order, or can be referenced by name
* code in fenced blocks gets concatenated.
* fenced code blocks become functions
  * function name is taken from section header
  * use language hint as `env`
* how to pick an entrypoint?
* can we potentially use different top-level interpreters?

## Python example
```python
print('hello world!')
```
## output from python example
```bash
mdsh_Python_example() {
  python <<< "print('hello world!')"
}
```
## parsing
```bash
sed -n '/^```/,/^```/p; /^```/,/^```/!{/^#/p}' toybox/literate_programming.md
# tokenize with M() into (name)(env)(code) triples
M '^```(.*)'$'\n''(.*)```'
echo "$name() { $env  \"\$@\" <<<\"$code\"; }"
```

# Reference
* [jupyter](https://jupyter.org/)
* [ipython](https://ipython.org/)
* [LP](http://literateprogramming.com/)
* [LP Wikipedia](https://en.wikipedia.org/wiki/Literate_programming)
* [literate shell](https://labs.consol.de/packer/2016/04/04/literate-shell-scripting.html)
# generalized computational model
source -> transformation -> sink

* IO is a stream of zero or more values
* inputs can be multiple steams
* a transformation may or may not emit an output for a given input
* there are multiple outputs
a shell langauge primarily deals with a 'stream' data structure and external transformations

# delays
code is executed immediately unless it is given a delay
* sink not ready delay - an output is directed to a sink that doesn't yet exist
* source not ready delay - an input has not been initialized
* lazy delay - only produce a value when one is requested
* function definition - definitions are run when called, not when defined

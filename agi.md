Current AI has this push towards a monolithic model that has all of these capabilities all at once, but I think that this approach is a dead end in pursuit of AGI. The approach implicitly assumes that a human mind is monolithic, or that all functional structures of cognitition can be effectively modeled in the same way. I simply don't believe this to be true.
This is my attempt at laying out a complete (but simplified) multi-part model of human cognition created with consideration to how these parts might map onto distinct computational structures of an AGI.

## Rich input
* biological senses
    * the basic 5
    * the passage of time
    * proprioception
    * etc. etc.
* language - as a 'sense' this is mediated through one or more of the biological senses, but is a distinct cross-section with internal rules and which provides a distinct method of transmitting information

## rich output
* a physical body, movement
* voice/writing - mediated through the body, but again, a distinct mode of output that corresponds more closely with language than any biological capability
* painting/drawing/sculpture - visual media output
* tool manipulation - a plugin system with the human hand as an interface

## agentic cognition
* desire
    * biological needs - hunger, thirst, etc.
    * control - a second order desire to not only solve the current base desire, but also to make it easier to solve in the future
    * curiosity - a cognitive desire founded upon the need to expand one's zone of control?
        * this is a base desire that balances cognition along the explore/exploit continuum
    * altruism - a base desire of eusocial beings, to balance the relatively selfish tendencies of the other base desires.
    * boredom - again, a pressure on the explore/exploit continuum
* goal setting

## reasoning
* [system 1 vs system 2 reasoning](https://thedecisionlab.com/reference-guide/philosophy/system-1-and-system-2-thinking)
    * system 1 - fast, automatic, intuitive
    * system 2 - deliberate, conscious, sometimes formal
* recognition primed decision making
    * system 1 - pattern matching against known problem-solution sets
    * system 2 - modeling/emulation of the problem domain to explore potential solutions

## memory
* the forgetting curve
* sometimes you 'know' something without having all of the nitty gritty detail
    * ie you've got the gist enough to reason about it at a high level.
    * or where to find the information if it is needed in detail.
    * this sort of implies that reasoning about a domain can be somewhat effectively pre-computed and cached separately from detailed reasoning within the domain. the mismatch can lead to errors that are only revealed upon closer inspection, but this happens all the time in conversation.
* short term and long term memory

# A high-level model of modular AGI
## social / conversational interface
* TTS - many options, doesn't even require AI
* turn prediction - sesame?
* STT - superwhisper
* a strong eusocial desire

## other IO
* rich input - can the AI receive more input than just the prompt given
    * computer vision
    * timeouts - a lack of response in a conversation is also a signal
    * follow links - if the user posts a link, the agent adds that page's content to the context
    * better training data
* rich output
    * image/video generation
    * audio/music generation - including TTS
    * robotic/physical outputs

## agentic behavior
The core of AGI is an [Intelligent Agent](https://en.wikipedia.org/wiki/Intelligent_agent)
which attempts to optimally satisfy its desires by tuning parameters on its subcomponents,
implementing 'consciousness' by selecting which competing components to use for output.

### desires
* balance of explore/exploit
    * too much exploration is naturally suboptimal, as exploitation provides immediate benefit
    * too much exploit manifests as boredom, can break out of the local optimum
    * novelty
* positive feedback from the user
    * this emulates the altruistic/eusocial drive
* control - second order over desires
    * gives an incentive to refine the control process even in the absence of a first order desire
* correctness - attempt to predict external signals
* consistency - attempt to have consistent output between competing/complementary subcomponents

### rewards
reward is modelled here as eudaemonia, or a lack of desires.
The desire for correctness, curiosity and control mean that this is never achieved.
* the desire for correctness drives the AI until it can perfectly model its environment
* the desire for novelty drives the AI to expand its environment

### imagination
* hypothetical situations used to tune subcomponents, in the model's downtime.
* it is degenerative to have an imaginary situation supply more of a reward than any real situation

### goal setting
based on the current desires, attempt to resolve those desires selecting which subcomponent to prioritize in controlling output.
Behavior is not 'random' but it will evolves over time, as goal-setting (esp. boredom) is a function of time. Hopefully there is enough feedback (or lack of feedback) to avoid looping behavior.

Although, degenerative patterns of looped behavior could be seen as an analog to addictive behaviours. Do the same solutions apply?

* agentic AI - can AI initiate a conversation to bring up relevant info (but not if there's nothing to say)?
    * this is in contrast to the 'default' where a response is generated in direct response to a prompt
    * modeled as desire?
    * manus
* history / memory
    * short term memory - controlling context
    * long term memory - adaptive AI - beyond processing more context, updating model weights through use
* qualitative reasoning core - for vibes based reasoning, or selecting when to use more formal reasoning
    * can the big 5 personality traits somehow be parameterized into this qualitative reasoning unit?
* RPD - a driver of curiosity

## hard reasoning
Some domains have closed form solutions to reasoning, which human minds can only approximate.
It is better to use hard reasoning when possible
* symbolic math engine (wolfram alpha)
* formal logic (SAT solver)
* prediction/emulation of physical systems
* statistical quantification of risk (assuming good priors are available)
    * bayesian inference
* fact checker - providing citations?

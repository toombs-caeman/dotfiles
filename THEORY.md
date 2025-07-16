# Project Philosophy
This isn't a well thought out manifesto or anything, but good tools do share certain qualities across vastly differnt domains.
I suppose I'll discuss what I think those are here as an aspirational rant.

# qualities of good tools
* simple:       should be predictable
* powerful:     should be capable
* reliable:     should work every time, in exactly the same way
* consistent:   should follow clear conventions
* composable:   should play nicely with others. no tool exists in a vacuum
* safe:         should have sane defaults, keep the guardrails on by default
* discoverable: should have good documentation

# rules of thumb
* keep tools as simple as possible, but no simpler
    * if you have to look up how something works every time you use it, it's too complicated.
    * if you have to compose a complicated pipeline to do anything useful, the tools are too simple.
    * it should be blindingly obvious which part is the handle, and where the pointy bits are.
* eliminate redundancy
    * redundanct tools are a complication that by definition don't offer extra functionality.
    * I'm clearly not talking about things like redundant backups, where multiplicity is itself a feature.
    * From the [Zen of Python](https://en.wikipedia.org/wiki/Zen_of_Python#Principles), there should be one and ideally only one obvious way to do something.
    * if you need more than one X to cover all use cases, your tools are too simple
* eliminate inconsistencies
    * tools that rely on the network will fail when the network is down.
    * tools that depend on specific versions of awk... or gawk... maybe it was mawk. Anyway you can never depend on having that exact version around. Bash is subtly different on linux and mac systems.
    * prefer dumb, consistent tools.
    * good tools are not novel, they behave exactly as expected every time.
* Tools should be composable and work together
    * This basically comes from [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), though I've soured on the idea of text streams being the best interface. It's a little too simple for a lot of things.
    * this is related to eliminating redundancy.
* Provide rich context
    * Indicate abnormal status but not the expected or default status
    * Rich means more concentrated, not just **more**. The ideal is that tools should deliver exactly what the user needs to know, right as they need to know it, and to otherwise stay quiet.
    * eliminate visual clutter. Clutter is by definition not important; it dilutes the signal.
    * cli context includes
        * what happened (history), what could happen (autocomplete) and what's happening (progress bars, etc)
        * who, what, where, when, why (user, command, directory+branch, timestamp, comments)
* The less I know the better
    * Fuzzy searching lets you stumble into the correct answer, even if you don't know exactly what you're looking for.
    * if I make a clear mistake, suggest a correction rather than just failing.
    * when it 'just works', you never have to think about how it works (or why it isn't working).
    * tools should protect you from doing something dumb (at least by accident).

* [proof affinity](https://the-nerve-blog.ghost.io/to-be-a-better-programmer-write-little-proofs-in-your-head/)

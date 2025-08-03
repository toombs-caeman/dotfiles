export extern "ollama" [
    command:string@"nu-complete command"
        --help(-h)
        --version(-v)
];
def 'nu-complete command' [] {
    [
        serve
        create
        show
        run
        stop
        pull
        list
        ps
        cp
        rm
        help
    ]

}
export extern "ollama run" [
    model:string@"nu-complete models"
    prompt:string=''
    --format:string      # Response format (e.g. json)
    --help(-h)               # help for run
    --hidethinking       # Hide thinking output (if provided)
    --insecure           # Use an insecure registry
    --keepalive:string   # Duration to keep a model loaded (e.g. 5m)
    --nowordwrap         # Don't wrap words to the next line automatically
    --think              # Whether to use thinking mode for supported models
    --verbose            # Show timings for response
]

def 'nu-complete models' [] {
    ollama list | detect columns | get NAME
}


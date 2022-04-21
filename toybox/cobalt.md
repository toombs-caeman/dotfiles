# Cobalt
This is an interaction language with [verbs that can act on many objects](http://gordonbrander.com/pattern/verbs-that-can-act-on-many-objects/).
It's purpose is to provide a uniform framework manipulation of things commonly manipulated on the commandline

## language principles
Sentences have one verb and a Noun. They represent a single command and have a canonical representation that approximates an english sentence.

Adverbs control whether Verbs ask for confirmation, go right ahead, or just explain the plan.
Verbs may mean slightly different things when applied to different Nouns.

Nouns describe one or more objects of a single type.
Nouns may be patterns or concrete.

Verbs can sometimes be omitted.
* Delete must always be specified
* Noun patterns can't be used with Create, so default to Open
* concrete Nouns specify Create then Open

## parts of speech
adverbs:
* forcefully  - don't confirm before exec
* politely    - confirm before exec
* plan to     - plan an action but don't execute it

verbs:
* Create - make a new thing. idempotent. No patterns.
* Open   - basically xdg_open, but don't actually use xdg_open.
* List   - list real objects that match Noun
* Delete - delete

nouns:
* url  - http(s) remote
* proj - refers to any project in scope (for now, git repositories under ~/)
  * should git internals also fit here? (commit, branch, file)
* dir  - a local directory
* file - a local file
* hist - shell history
* ssh  - ssh remote
* here ? current diretory as either DIR or PROJ
* host ? the remote of current PROJ
* k8s  ? kubernetes resources


## examples
* Url
    * Create - add bookmark
    * Open   - xdg_open in $BROWSER, never autocreate
    * List   - list bookmarks
    * Delete - remove bookmarks

* Proj
    * Create - git init and push to remote. remote is known since canonically named by url
    * Open   - cd Proj
    * List   - find ~ -type d -name '.git'
    * Delete - rm Proj. Polite unless its clean and all branches are pushed.

* Dir
    * Create - mkdir
    * Open   - cd
    * List   - ls
    * Delete - rmdir

* File
    * Create - touch
    * Open   - $EDITOR
    * List   - ls
    * Delete - rm
* Hist
    * Create ?
    * Open   - re-run command
    * List   - list command
    * Delete ?
* Ssh
    * Create ?
    * Open   - connect to host
    * List   - list known hosts
    * Delete - remove from known hosts
* Here
    * Create - git fetch?
    * Open   - git pull
    * List   - ls .
    * Delete - git reset HEAD
* Host
    * Open - connect to host
    * List - list hosts
    * Delete - remove from known hosts

## technical design
* use a keybinding to start interactively building a plan, when complete, append it to the existing input line. potentially wrapped in "$()"
* iteratively refine the Noun until confirmed somehow. Display the default verb too.
* Like git, seperate porcelain from plumbing

plumbing commands:
* parse - generate a type from a NOUN
* list - print a concrete list of items matching a NOUN. return 0 if at least one item
* exec - execute a plan (which may be just a describe)

porcelain
* query - interactively build a plan
* vim plugin - vim bindings?

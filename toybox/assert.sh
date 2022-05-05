#!/bin/bash
#
#     /| |\
#    /||_||\
#   {,|||||,}
#   /   |   \
#  <  \ | / |
#  <\_  |  _/
#    v\ | /-
#      \@/

#    _     _
#   /_\   /_\
#  // \\ // \\
# (/_/w)_(w\_\)
# )  ,,   ,,  >
#  \ 0\   /0 /
# --\  | |  /--
#  --\__@_ /--
#
# if we're not sourced, return the name of this file and exit
# if sourced by bash, `$0=*bash`, if sourced by zsh `$0=*lib` but $BASH_SOURCE isn't set
if [ "${0##*/}" = "lib" ] && [ -n "$BASH_SOURCE" ]; then
    echo "$BASH_SOURCE"
    exit
fi

# pre-conditions
: '
env frozen to when runner starts
'
# post-conditions
: '

assert_stdout_equals
assert_stderr_equals
assert_return_code_equals
assert_timeout - assert command finishes before timeout
assert_var_equals - check shell variable
assert_env_equals - check env variable
assert_func_equals - check shell function definition
assert_raise_signal -
assert_file_modified - 
assert_fd_closed -
'
# cleanup
: '
'
# mock
: '
commands that that might have external effects are replaced by manipulating PATH

'
# runner - collect tests to be run, summarize results
: '
'

__assert_cases=(out err ret fun)
for name in require mock precmd cmd assert; do
    eval "$name() { __case__$name=(\"\$@\"); }"
done

# each testcase is a function named 'test_*'
test_fmt_Txx() {
    # this test requires tput to be on the path
    require tput
    # precmd is run in the subshell to setup the test
    precmd . "$(lib)"
    # this is the command we're testing
    cmd fmt '%T--'
    assert -oer # assert that stdOut stdErr and Return code are the same as this function
    tput sgr0
}

freeze() { : 'capture the current environment to check against'; }
restore() {
    # restore env between tests
    for c in "${__assert_cases[@]}"; do
        unset __test__$c __case__$c
    done
}

runner() {
    # collect tests
    set -- "${tests[@]}"
    __runner_cleanup() {
        rm --  $__case__out $__case__err $__test__out $__test__err
    }
    trap __runner_cleanup SIGEXIT
    # ideal values
    __case__out="$(mktemp)"
    __case__err="$(mktemp)"
    # actual values
    __test__out="$(mktemp)"
    __test__err="$(mktemp)"
    while (($#)) {
        # defaults
        __case__assert=(ret)
        # load context
        "$1" > "$__case__out" 2> "$__case__err"
        __case__ret=$?
        # run cmd
        eval "\"\${${1}__cmd[@]}\"" > "$__test__out" 2> "$__test__err"
        __test__ret=$?
        for c in "${__assert_cases[@]}"; do
            eval "[ \"\$__test__$c\" != \"\$__case__$c\" ] &&echo \"failed: $1: $c: '\$__test__$c' != '\$__case__$c'\""
        done
        shift
    }
}


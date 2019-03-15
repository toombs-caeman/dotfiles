#!/bin/bash

infect options git

git_shell() {
    infect prefix "git $* " "git> "
}
subtool git

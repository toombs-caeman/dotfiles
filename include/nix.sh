nix() {
    [[ "$(uname -a)" == *"nix"* ]]
}
nix || return 0

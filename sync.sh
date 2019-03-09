# initialize the repo if it's missing
REMOTE=https://github.com/toombs-caeman/dotfiles/
if [ ! -d "$REMOTE_CONFIG_DIR" ];then
    git clone $REMOTE $REMOTE_CONFIG_DIR
fi

reconfig() {
    # if there are changes to the upstream
    # pull the new changes and load those instead
    git --git-dir $REMOTE_CONFIG_DIR/.git fetch
    if [ $(git --git-dir $REMOTE_CONFIG_DIR/.git rev-parse HEAD) != $(git --git-dir $REMOTE_CONFIG_DIR/.git rev-parse @{u}) ]; then
        # pull and start processing the new file instead
        git --git-dir $REMOTE_CONFIG_DIR/.git pull && source $REMOTE_CONFIG_DIR/remote_config.sh
    fi
}

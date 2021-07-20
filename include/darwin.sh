# only run if the system is mac/OSX
darwin() {
	[[ $(uname -a) == *"Darwin"* ]]
}
darwin || return 0

beep() {
    osascript -e 'beep 3'
}
notify() {
    osascript -e "display notification \"${1:-"Done"}\""
}

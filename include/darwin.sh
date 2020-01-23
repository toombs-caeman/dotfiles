# only run if the system is mac/OSX
darwin() {
	[[ $(uname -a) == *"Darwin"* ]]
}
darwin || return 0

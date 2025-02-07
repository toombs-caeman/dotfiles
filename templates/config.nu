# prompt hooks https://www.nushell.sh/book/hooks.html

$env.config.show_banner = false

$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
alias vi = nvim

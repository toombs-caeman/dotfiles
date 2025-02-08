# prompt hooks https://www.nushell.sh/book/hooks.html
# completers https://www.nushell.sh/cookbook/external_completers.html

$env.config.show_banner = false

$env.config.edit_mode = 'vi'
$env.config.buffer_editor = 'nvim'
alias vi = nvim

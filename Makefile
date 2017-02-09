update:
	git pull

install: symlinks dirs

dirs:
	mkdir -p tasks

symlinks:
	ln -s bashrc ~/.bashrc
	ln -s vim/vimrc ~/.vimrc
	ln -s vim/ ~/.vim/
	ln -s zsh/zshrc ~/.zshrc
	ln -s zsh/oh-my-zsh ~/.oh-my-zsh/



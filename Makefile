DIR=~/dotfiles/

update:
	git pull

install: symlinks dirs git

git:
	git submodule init
	git submodule update
	
dirs:
	mkdir -p tasks

symlinks:
	ln -s $(DIR)/bashrc ~/.bashrc
	ln -s $(DIR)/vim/vimrc ~/.vimrc
	ln -s $(DIR)/vim ~/.vim
	ln -s $(DIR)/zsh/zshrc ~/.zshrc
	ln -s $(DIR)/zsh/oh-my-zsh ~/.oh-my-zsh
	# link zsh theme
	ln -s $(DIR)/zsh/tombstone.zsh-theme $(DIR)/zsh/oh-my-zsh/themes

rmlinks:
	rm -f  ~/.bashrc
	rm -f  ~/.vimrc
	rm -rf ~/.vim
	rm -f  ~/.zshrc
	rm -rf ~/.oh-my-zsh

clean: rmlinks

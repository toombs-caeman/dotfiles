

update:
	git pull

install: symlinks dirs
	git submodule init


	
dirs:
	mkdir -p tasks

symlinks:
	ln -s ~/dotfiles/bashrc ~/.bashrc
	ln -s ~/dotfiles/vim/vimrc ~/.vimrc
	ln -s ~/dotfiles/vim ~/.vim
	ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
	ln -s ~/dotfiles/zsh/oh-my-zsh ~/.oh-my-zsh

rmlinks:
	rm -f  ~/.bashrc
	rm -f  ~/.vimrc
	rm -rf ~/.vim
	rm -f  ~/.zshrc
	rm -rf ~/.oh-my-zsh

clean: rmlinks
	

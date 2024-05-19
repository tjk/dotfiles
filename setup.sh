#!/bin/sh -ex
# XXX tweak git clones to update? or specify ref to lock at?
install_brew() {
	# bash required to intrepret this script
	NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	[ -d /home/linuxbrew ] && echo '#!/bin/sh\neval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' > ~/.zprofile_brew
	[ -d /opt/homebrew ] && echo '#!/bin/sh\neval $(/opt/homebrew/bin/brew shellenv)' > ~/.zprofile_brew
	source ~/.zprofile_brew
}
which brew || install_brew
which stow || brew install stow

CONFIG=$HOME/.config

mkdir -p $CONFIG

# git
ln -sf $(pwd)/gitignore $HOME/.gitignore
ln -sf $(pwd)/gitconfig $HOME/.gitconfig

# nvim
mkdir -p $CONFIG/nvim
stow --restow --target=$CONFIG/nvim nvim

# tmux
ln -sf $(pwd)/tmux.conf $CONFIG/.tmux.conf

# zsh
ln -sf $(pwd)/zshrc $HOME/.zshrc
ln -sf $(pwd)/p10k.zsh $HOME/.p10k.zsh

OMZ="$HOME/.oh-my-zsh"
[ ! -d "$OMZ" ] && CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}"
brew install zsh-syntax-highlighting
[ ! -d $OMZ/custom/plugins/zsh-autosuggestions ] && git clone https://github.com/zsh-users/zsh-autosuggestions $OMZ/custom/plugins/zsh-autosuggestions
[ ! -d $OMZ/themes/powerlevel10k ] && git clone https://github.com/romkatv/powerlevel10k.git $OMZ/themes/powerlevel10k
brew install ripgrep # for CocList

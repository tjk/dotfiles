# XXX fix a bunch of mac specific stuff in here
alias vi='nvim'
alias vim='nvim'
alias ze="nvim $HOME/.zshrc"
alias zs=". $HOME/.zshrc"
alias gs='git status -sb'
alias cds="cd $HOME/src/github.com"
alias cdpd="cd $HOME/src/github.com/PipedreamHQ/pipedreamin"
alias cdd="cd $HOME/src/github.com/tjk/dotfiles"

# homebrew installs stuff in here
export PATH="/usr/local/sbin:$PATH"
# fixes mysql2 gem installation (https://github.com/brianmario/mysql2/issues/795#issuecomment-655885415)
export LIBRARY_PATH="/usr/local/opt/openssl/lib/:$LIBRARY_PATH"

# setup.sh sets this depending on whether we setup mac or linux
export HOMEBREW_NO_AUTO_UPDATE=1
source $(brew --prefix asdf)/asdf.sh

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # pipx

# Created by `pipx` on 2021-03-05 03:33:41
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

source $(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:$HOME/src/github.com/sumneko/lua-language-server/bin"

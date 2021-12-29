# XXX fix a bunch of mac specific stuff in here
eval "$(ssh-agent -s)"

alias ls='/bin/ls -G'
alias vi='nvim'
alias vim='nvim'
alias ze='vi ~/.zshrc'
alias zs='. ~/.zshrc'
alias gs='git status -sb'
alias cds='cd ~/src/github.com'
alias cdpd='cd ~/src/github.com/PipedreamHQ/pipedreamin'

# homebrew installs stuff in here
export PATH="/usr/local/sbin:$PATH"
# fixes mysql2 gem installation (https://github.com/brianmario/mysql2/issues/795#issuecomment-655885415)
export LIBRARY_PATH="/usr/local/opt/openssl/lib/:$LIBRARY_PATH"

source $(brew --prefix asdf)/asdf.sh
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH" # pipx

# Created by `pipx` on 2021-03-05 03:33:41
export PATH="$PATH:$HOME/Library/Python/3.9/bin"

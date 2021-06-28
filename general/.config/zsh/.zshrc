
# Initialize p10k if present
# if [[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
# else
  # ZSH_THEME="robbyrussell"
# fi

# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/zsh/oh-my-zsh"
# export ZSH="~/.oh-my-zsh"

### ZPLUG ###

# Install zplug through AUR
source /usr/share/zsh/scripts/zplug/init.zsh

zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "supercrabtree/k"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "wting/autojump", \
      use:"bin/autojump.zsh"

# TODO: figure out how to use redrawhook syntax highlight with autosuggestions
# zplug "zsh-users/zsh-syntax-highlighting", \
#       at:"feature/redrawhook"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

export ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  vscode
  vi-mode
  systemd
  # npm
  # npx
  node
  flutter
  archlinux
  colorize
  docker
  docker-compose
  pip
  python
)

source $ZSH/oh-my-zsh.sh

source ~/.aliases

export HISTFILE="$ZDOTDIR/.zsh_history"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f !/.zshrc.local ]] || source ~/.zshrc.local

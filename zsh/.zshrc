# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi




###########################################################
# ZPLUG
# ##########################################################

if [ -f ~/.zplug/init.zsh ]; then
  source ~/.zplug/init.zsh

  zplug "paulirish/git-open", as:plugin
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "nobeans/zsh-sdkman", as:plugin
  zplug "kiurchv/asdf.plugin.zsh", defer:2
  zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf
  zplug "mdumitru/git-aliases", as:plugin

# Add Powerlevel10k
  zplug romkatv/powerlevel10k, as:theme, depth:1
  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed"
fi



################################################################################
# SET OPTIONS
################################################################################
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

# completions
setopt COMPLETE_ALIASES

# automatically CD without typing cd
setopt AUTOCD

# Dealing with history
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY
HIST_STAMPS="mm/dd/yyyy"

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history

# History: Number of history entries to save to disk
export SAVEHIST=5000


#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

#######################################################################
# fzf SETTINGS
#######################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_OPTS="--bind=ctrl-o:toggle-preview --ansi --preview 'bat {}' --preview-window hidden"
FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"' \
export FZF_DEFAULT_COMMAND




################################################################################
# ZShell Auto Completion
################################################################################

autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# CURRENT STATE: does not select any sort of searching
# searching was too annoying and I didn't really use it
# If you want it back, use "search-backward" as an option
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# Manual libraries


# stack
# eval "$(stack --bash-completion-script stack)"

# Add autocompletion path
fpath+=~/.zfunc



######################################################################
# FUNCTIONS
######################################################################

function klone() {
  if [[ ! -d ~/kepler-repos/$1 ]]; then
    git clone git@github.com:KeplerGroup/$1.git ~/kepler-repos/$1
  else
    echo "Repo is already kloned!"
  fi
}




function switchenv() {
  # Switch only the environment in the CWD
  # Requires environment as an argument
  # Example: switchenv master
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  ENV=$(echo ${DIR} | sed "s/^.*\/kepler-terraform\///" | cut -d / -f 1)
  DIR_PREFIX=$(echo $DIR | awk -F "${ENV}" '{print $1}')
  DIR_SUFFIX=$(echo $DIR | awk -F "${ENV}" '{print $2}')
  if [[ $ENV == 'master' ]]; then
    NEW_ENV='integration'
  elif [[ $ENV == 'integration' ]]; then
    NEW_ENV='master'
  else
    NEW_ENV=$1
  fi
  cd "$DIR_PREFIX/$NEW_ENV/$DIR_SUFFIX"
}

# cd to the current git root
function td() {
  local dir
  dir=`git rev-parse --show-toplevel`
  if [ $? -eq 0 ]; then
    cd "$dir"
    return 0
  else
    return 1
  fi
}



function update_program() {
  case $1 in
    kitty)
      curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
      ;;
    zoom)
      curl -Lsf https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb
      sudo dpkg -i /tmp/zoom_amd64.deb
      ;;
    vault)
      if [ -z $2 ]; then
        echo "Missing Vault Version!"
      else
        curl -Lsf https://releases.hashicorp.com/vault/${2}/vault_${2}_linux_amd64.zip -o /tmp/vault.zip
        unzip -o -d $HOME/.local/bin/ /tmp/vault.zip
        echo "Updated Vault to $2"
      fi
      ;;
  esac
}

function get_ips() {
  if [ -z "$1" ]; then
    echo "Must Define an Instance Name! eg mgmt-ecs-asg"
  else
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].{Instance:InstanceId,PrivateIP:PrivateIpAddress}' --output table
  fi
}



######################################################################
#ALIASES
######################################################################
alias kvpn="nmcli c up aws"
alias svpn="nmcli c down aws"

alias vauth='vault login -method=github'

alias sl='ls --color=auto'
alias ls='ls --color=auto'
alias ll='ls -alFh --color=auto'
alias la='ls -Alfh --color=auto'
alias cat='bat'

alias pbcopy='xsel --clipboard --input'

alias zo='source ~/.zshrc'
alias ve='python3 -m venv venv'
alias va='source venv/bin/activate'
alias kipt='cd ~/kepler-repos/kepler-terraform'
alias kip='cd ~/kepler-repos'
alias vgit='echo $VAULT_AUTH_GITHUB_TOKEN | pbcopy'
alias eget='echo "961517735772.dkr.ecr.us-east-1.amazonaws.com" | pbcopy'
alias tmux='tmux -2 -f ~/.tmux.conf'
alias smux='tmuxinator start devops'
alias dmux='tmuxinator stop devops'
alias python='python3'
alias vim='nvim'
alias rg="rg --hidden"
alias f="nvim"

alias goans='cd ~/kepler-repos/kepler-ansible'
alias gomod='cd ~/kepler-repos/kepler-terraform-modules'
alias gopack='cd ~/kepler-repos/kepler-packer'
alias officevpn="sudo netExtender -u janderson@keplergrp.com -d LocalDomain svpn.keplergrp.com:4433"
alias homevpn="sudo openvpn --config ~/openvpn/janderson.ovpn"
alias cookies3="cookiecutter git@github.com:keplergroup/cookiecutter-terraform-s3-bucket.git"
alias cookieci="cookiecutter git@github.com:keplergroup/cookiecutter-ci-files.git"

alias indbabel='babel src/app.js --out-file=public/scripts/app.js --presets=env,react --watch'

alias awho="aws sts get-caller-identity"

alias ghview="gh repo view -w"
alias prlist="gh pr list"
alias prstatus="gh pr status"

alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias ......='cd ../../../../../..'
alias .......='cd ../../../../../../..'
alias ........='cd ../../../../../../../..'
alias .........='cd ../../../../../../../../..'
alias ..........='cd ../../../../../../../../../..'

alias tfrm='terraform state rm '
alias tfmv='terraform state mv '
alias tflist='terraform state list'

#tmux alias
alias t='tmux'
alias ta='t a -t'
alias tls='t ls'
alias tn="t new -t"


################################################################
#PATH
################################################################

PATH=$PATH::$HOME/.local/bin
export PATH

################################################################
#Set EDITOR
################################################################
export EDITOR='nvim'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.u
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Hook direnv into your shell.
if [[ -f $(which direnv) ]]; then
  eval "$(direnv hook $SHELL)"
fi

export PATH="$HOME/.poetry/bin:$PATH"

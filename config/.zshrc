# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Frenzy's
# ███████ ███████ ██   ██      ██████  ██████  ███    ██ ███████ ██  ██████  
#    ███  ██      ██   ██     ██      ██    ██ ████   ██ ██      ██ ██       
#   ███   ███████ ███████     ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
#  ███         ██ ██   ██     ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
# ███████ ███████ ██   ██      ██████  ██████  ██   ████ ██      ██  ██████  

if [[ $- != *i* ]]; then
	return
fi

if ! (( $+commands[tmux] )); then
  print "tmux not found. Dude, install Tmux, its gud" >&2
  return 1
fi


# --------------------------------------------------------------------------
# TMUX auto initializer, stripped from OH-MY-ZSH (partially lol)
# CONFIGURATION VARIABLES
# Automatically start tmux
: ${ZSH_TMUX_AUTOSTART:=false}
# Only autostart once. If set to false, tmux will attempt to
# autostart every time your zsh configs are reloaded.
: ${ZSH_TMUX_AUTOSTART_ONCE:=true}
# Automatically connect to a previous session if it exists
: ${ZSH_TMUX_AUTOCONNECT:=true}
# Automatically close the terminal when tmux exits
: ${ZSH_TMUX_AUTOQUIT:=$ZSH_TMUX_AUTOSTART}
# Set term to screen or screen-256color based on current terminal support
: ${ZSH_TMUX_FIXTERM:=true}
# The TERM to use for non-256 color terminals.
# Tmux states this should be screen, but you may need to change it on
# systems without the proper terminfo
: ${ZSH_TMUX_FIXTERM_WITHOUT_256COLOR:=screen}
# The TERM to use for 256 color terminals.
# Tmux states this should be screen-256color, but you may need to change it on
# systems without the proper terminfo
: ${ZSH_TMUX_FIXTERM_WITH_256COLOR:=screen-256color}
# Set the configuration path
: ${ZSH_TMUX_CONFIG:=$HOME/.tmux.conf}
# Set -u option to support unicode
: ${ZSH_TMUX_UNICODE:=false}

# Determine if the terminal supports 256 colors
if [[ $terminfo[colors] == 256 ]]; then
  export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
else
  export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
fi

# Set the correct local config file to use.
if [[ -e "$ZSH_TMUX_CONFIG" ]]; then
  export ZSH_TMUX_CONFIG
  export _ZSH_TMUX_FIXED_CONFIG="~/tmux.extra.conf"
fi

# Wrapper function for tmux.
function _zsh_tmux_plugin_run() {
  if [[ -n "$@" ]]; then
    command tmux "$@"
    return $?
  fi

  local -a tmux_cmd
  tmux_cmd=(command tmux)
  [[ "$ZSH_TMUX_ITERM2" == "true" ]] && tmux_cmd+=(-CC)
  [[ "$ZSH_TMUX_UNICODE" == "true" ]] && tmux_cmd+=(-u)

  # Try to connect to an existing session.
  [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]] && $tmux_cmd attach

  # If failed, just run tmux, fixing the TERM variable if requested.
  if [[ $? -ne 0 ]]; then
    if [[ "$ZSH_TMUX_FIXTERM" == "true" ]]; then
      tmux_cmd+=(-f "$_ZSH_TMUX_FIXED_CONFIG")
    elif [[ -e "$ZSH_TMUX_CONFIG" ]]; then
      tmux_cmd+=(-f "$ZSH_TMUX_CONFIG")
    fi
    $tmux_cmd new-session
  fi

  if [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]]; then
    exit
  fi
}

# Alias tmux to our wrapper function.

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
    export ZSH_TMUX_AUTOSTARTED=true
    _zsh_tmux_plugin_run
  fi
fi

# --------------------------------------------------------------------------

# ---| Increase key speed via rate change |--- #
xset r rate 300 50

# ---| Completion Cache Path Setup |--- #
typeset -g comppath="$HOME/.cache"
typeset -g compfile="$comppath/.zcompdump"

if [[ -d "$comppath" ]]; then
	[[ -w "$compfile" ]] || rm -rf "$compfile" >/dev/null 2>&1
else
	mkdir -p "$comppath"
fi

# ---| zsh Internal Stuff |--- #
SHELL=$(which zsh || echo '/bin/zsh')
KEYTIMEOUT=1
SAVEHIST=10000
HISTSIZE=10000
HISTFILE="$HOME/.cache/.zsh_history"

# ---| Aliases |--- #

# Goto some Place
alias gotoDownloads='cd ~/Downloads/'
alias gotoDocuments='cd ~/Documents/'
alias gotoPictures='cd ~/Pictures/'
alias gotoWallpapers='cd ~/Pictures/wallpapers/'
alias gotoMusic='cd ~/Music/'

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
# But its full of Inspector Gadged references
alias gogoPacmanInstall='sudo pacman -S'
alias gogoPacmanUnninstall='sudo pacman -R'
alias gogoPacmanInstallUpdate='sudo pacman -Syu'
alias gogoPacmanUpgrade="sudo pacman -U"
alias gogoPacmanAnnihilate="sudo pacman -Rns"
alias gogoPacmanListExplicit="sudo pacman -Qe"
alias gogoPacmanListModified="pacman -Qii | awk '/^MODIFIED/ {print $2}'"
alias gogoPacmanListAll="pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h"
alias gogoPacmanListFancy="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias gogoPacmanArmaggedon="sudo pacman -D --asdeps $(pacman -Qqe)"
alias gogoPacmanBackUp="tar -cjf pacman_database.tar.bz2 /var/lib/pacman/local"
alias gogoPacmanQueryInfo="pacman -Qi"
alias gogoPacmanSearchQuery="pacman -Qs"


# Tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# MPD
alias mpd_start='systemctl start mpd.service mpdscribble.service --user'
alias mpd_stop='systemctl stop mpd.service mpdscribble.service --user'

# List Something
alias la='ls -Ah'
alias ll='ls -lAh'

# Other
alias music-player='ncmpcpp'
alias py ='python3'
alias z ='zathura'
alias r ='ranger'

# Archives
alias mtar='tar -zcvf' # mtar <archive_compress>
alias utar='tar -zxvf' # utar <archive_decompress> <file_list>
alias z='zip -r' # z <archive_compress> <file_list>
alias uz='unzip' # uz <archive_decompress> -d <dir>

# Git
alias gi='git init'
alias gs='git status -sbu'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gp='git push'
alias ga='git add .'
alias gm='git merge'
alias gst='git stash'
alias gstl='git stash list'
alias glg='git log --graph --oneline --decorate --all'

# Some basic commands
alias cp='cp -iv -r'
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

alias grep='grep --color=auto'

# Systemctl
alias stlsa="sudo systemctl start"
alias stlst="sudo systemctl stop"
alias stlsu="sudo systemctl status"
alias stlre="sudo systemctl restart"
alias stlen="sudo systemctl enable --now"
alias stldis="sudo systemctl disable"

# Configs
alias config="nvim ~/.zshrc"
alias config-bspwm="nvim ~/.config/bspwm/bspwmrc"
alias config-sxhkd="nvim ~/.config/sxhkd/sxhkdrc"
alias config-nvim="nvim ~/.config/nvim/init.vim"
alias config-zathura="nvim ~/.config/zathura/zathurarc"
alias config-dunst="nvim ~/.config/dunst/dunstrc"
alias config-alacritty="nvim ~/.config/alacritty/alacritty.yml"
alias config-polybar-bars="nvim ~/.config/polybar/config"
alias config-polybar-modules="nvim ~/.config/polybar/modules.ini"
alias config-picom="nvim ~/.config/picom.conf"

# Network
alias net-h='https://linuxhint.com/arch_linux_network_manager/'
alias net-show='nmcli connection show'
alias net-dev='nmcli device'
alias net-up='nmcli connection up uuid'
alias net-deco='nmcli device disconnect'



# Update something
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mirror-update='sudo reflector --verbose --score 100 -l 50 -f 10 --sort rate --save /etc/pacman.d/mirrorlist'
alias update-packages='sudo pacman -Syu'

# ---| Turn Ctrl+Z into a toggle switch |--- #
ctrlz() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}
zle -N ctrlz
bindkey '^Z' ctrlz


# ---| Functions N Stuff |---

# ls with preferred arguments
ls() {
	command ls --color=yes -F1 "$@" | more --clean-print --lines 10
}

# cd and ls after
cd() {
	builtin cd "$@" && command ls --color=auto -F
}

# Recompile completion and Reload ZSH
src() {
	autoload -U zrecompile
	rm -rf "$compfile"*
	compinit -u -d "$compfile"
	zrecompile -p "$compfile"
	exec zsh
}

# Some ranger Function thing
function ranger_level {
	if [ -z "$RANGER_LEVEL" ]
	then
	    string_level=""
	else
	    string_level=" ranger │"
	fi
}

# Lang
export LANG=en_US.UTF-8

# less/manpager colours
export MANWIDTH=80
export LESS='-R'
export LESSHISTFILE=-
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[32m'
export LESS_TERMCAP_mb=$'\e[31m'
export LESS_TERMCAP_md=$'\e[31m'
export LESS_TERMCAP_so=$'\e[47;30m'
export LESSPROMPT='?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'

# Ditch Nano, join the NeoVim Team
export EDITOR=/usr/bin/nvim
export SUDO_EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# ---| Git Prompt |---
ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) %{$fg_bold[green]%}✓%{$reset_color%}"

# git status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ⌥" 
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ⌘"

# Some Rust Lang thing idk
export PATH="$HOME/.cargo/bin:$PATH"

export BROWSER=/usr/bin/qutebrowser

# completion
setopt CORRECT
setopt NO_NOMATCH
setopt LIST_PACKED
setopt ALWAYS_TO_END
setopt GLOB_COMPLETE
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD

# builtin command behaviour
setopt AUTO_CD

# job control
setopt AUTO_CONTINUE
setopt LONG_LIST_JOBS

# history control
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# misc
setopt EXTENDED_GLOB
setopt TRANSIENT_RPROMPT
setopt INTERACTIVE_COMMENTS


autoload -U compinit     # completion
autoload -U terminfo     # terminfo keys
zmodload -i zsh/complist # menu completion
autoload -U promptinit   # prompt

# better history navigation, matching currently typed text
autoload -U up-line-or-beginning-search; zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search; zle -N down-line-or-beginning-search

# set the terminal mode when entering or exiting zle, otherwise terminfo keys are not loaded
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	zle-line-init() { echoti smkx; }; zle -N zle-line-init
	zle-line-finish() { echoti rmkx; }; zle -N zle-line-finish
fi

# Some ranger Stuff
if [ -n "${RANGER_LEVEL}" ]; then
	    ranger_level="%{%K{cyan}%B%F{white}%} ranger %{%b%K{magenta}%F{cyan}%}"
else
    	    ranger_level="%{%K{magenta}%F{cyan}%}"
fi


exp_alias() # expand aliases to the left (if any) before inserting the key pressed
{ # expand aliases
	zle _expand_alias
	zle self-insert
}; zle -N exp_alias

zshAddHistory() {
	whence ${${(z)1}[1]} >| /dev/null || return 1
}

# bind keys not in terminfo
bindkey -- ' '     exp_alias
bindkey -- '^K'    kill-line
bindkey -- '^W'	   backward-kill-word
bindkey -- '^P'    up-history
bindkey -- '^N'    down-history
bindkey -- '^R'    history-incremental-pattern-search-backward
bindkey -- '^F'    history-incremental-pattern-search-foward
bindkey -- '^E'    end-of-line
bindkey -- '^A'    beginning-of-line
bindkey -- '^[^M'  self-insert-unmeta # alt-enter to insert a newline/carriage return
bindkey -- '^[05M' accept-line # fix for enter key on some systems

# [Alt+p] => Append less to a command
bindkey -s '\ep' '^e | less'

# [Alt+'] => Write double quotes and place the cursor in the middle
bindkey -s '\e'\' '""^[[D'

# default shell behaviour using terminfo keys
[[ -n ${terminfo[kdch1]} ]] && bindkey -- "${terminfo[kdch1]}" delete-char                   # delete
[[ -n ${terminfo[kend]}  ]] && bindkey -- "${terminfo[kend]}"  end-of-line                   # end
[[ -n ${terminfo[kcuf1]} ]] && bindkey -- "${terminfo[kcuf1]}" forward-char                  # right arrow
[[ -n ${terminfo[kcub1]} ]] && bindkey -- "${terminfo[kcub1]}" backward-char                 # left arrow
[[ -n ${terminfo[kich1]} ]] && bindkey -- "${terminfo[kich1]}" overwrite-mode                # insert
[[ -n ${terminfo[khome]} ]] && bindkey -- "${terminfo[khome]}" beginning-of-line             # home
[[ -n ${terminfo[kbs]}   ]] && bindkey -- "${terminfo[kbs]}"   backward-delete-char          # backspace
[[ -n ${terminfo[kcbt]}  ]] && bindkey -- "${terminfo[kcbt]}"  reverse-menu-complete         # shift-tab
[[ -n ${terminfo[kcuu1]} ]] && bindkey -- "${terminfo[kcuu1]}" up-line-or-beginning-search   # up arrow
[[ -n ${terminfo[kcud1]} ]] && bindkey -- "${terminfo[kcud1]}" down-line-or-beginning-search # down arrow

# ---| Correction  and Autocompletion |--- #
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:approximate:*' max-errors 'reply=($(( ($#PREFIX + $#SUFFIX) / 3 )) numeric)'

# completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$comppath"
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose true
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:-command-:*:' verbose false
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' completer _complete _match _approximate _ignored
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# labels and categories
zstyle ':completion:*' group-name ''
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description 'Introduce %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{green}->%F{yellow} %d%f'
zstyle ':completion:*:messages' format ' %F{green}->%F{purple} %d%f'
zstyle ':completion:*:descriptions' format ' %F{green}->%F{yellow} %d%f'
zstyle ':completion:*:warnings' format ' %F{green}->%F{red} no matches%f'
zstyle ':completion:*:corrections' format ' %F{green}->%F{green} %d: %e%f'

# menu colours
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=36=0=01'

# command parameters
zstyle ':completion:*:functions' ignored-patterns '(prompt*|_*|*precmd*|*preexec*)'
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
zstyle ':completion:*:(vim|nvim|vi|nano):*' ignored-patterns '*.(wav|mp3|flac|ogg|mp4|avi|mkv|iso|so|o|7z|zip|tar|gz|bz2|rar|deb|pkg|gzip|pdf|png|jpeg|jpg|gif)'

# hostnames and addresses
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
zstyle -e ':completion:*:hosts' hosts 'reply=( ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ } ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*} ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})'
ttyctl -f

# initialize completion
compinit -u -d "$compfile"

# initialize prompt with a decent built-in theme
promptinit
prompt adam1

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias luamake=/home/frenzy/lua-language-server/3rd/luamake/luamake

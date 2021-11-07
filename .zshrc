#! /bin/zsh

###############################################################
# ______ _____ _   _   _____ _____ _   _ ______ _____ _____   #
# |___  //  ___| | | | /  __ \  _  | \ | ||  ___|_   _|  __ \ #
#    / / \ `--.| |_| | | /  \/ | | |  \| || |_    | | | |  \/ #
#   / /   `--. \  _  | | |   | | | | . ` ||  _|   | | | | __  #
# ./ /___/\__/ / | | | | \__/\ \_/ / |\  || |    _| |_| |_\ \ #
# \_____/\____/\_| |_/  \____/\___/\_| \_/\_|    \___/ \____/ #
#                                                             #
# By Detective Pikachu                                        #
###############################################################

if [[ $- != *i* ]]; then
	return
fi

# completion cache path setup
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

# ls aliases
alias la='ls -Ah'
alias ll='ls -lAh'

# Grep
alias grep='grep --color=auto'

# Update thingy
alias grub-update='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mirror-update='sudo reflector --verbose --score 100 -l 50 -f 10 --sort rate --save /etc/pacman.d/mirrorlist'

# Pacman, but its too verbose
alias gPacU='sudo pacman -R'
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


# Other
alias m-player='ncmpcpp'

# Lang
alias py='python3'
alias ru='rust'
alias jv='java'

# Archives
alias mtar='tar -zcvf' # mtar <archive_compress>
alias utar='tar -zxvf' # utar <archive_decompress> <file_list>
alias z='zip -r' # z <archive_compress> <file_list>
alias uz='unzip' # uz <archive_decompress> -d <dir>

# Git
alias gi='git init' \
      gs='git status -sbu' \
      gco='git checkout' \
      gcob='git checkout -b' \
      gp='git push' \
      ga='git add .' \
      gm='git merge' \
      gst='git stash' \
      gstl='git stash list' \
      glg='git log --graph --oneline --decorate --all' \
      gu="git submodule foreach '(git checkout master || git checkout set_net_wm_pid) && git pull'" \
      gC="git remote prune origin && git repack && git prune-packed && git reflog expire --expire=1.month.ago && git gc"

# MPD
alias mpd_start='systemctl start mpd.service mpdscribble.service --user'
alias mpd_stop='systemctl stop mpd.service mpdscribble.service --user'

# Some basic commands
alias cp='cp -iv -r'
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

# Systemctl
alias stlsa="sudo systemctl start"
alias stlst="sudo systemctl stop"
alias stlsu="sudo systemctl status"
alias stlre="sudo systemctl restart"
alias stlen="sudo systemctl enable --now"
alias stldis="sudo systemctl disable"

alias diff="diff --color=auto"

alias v="nvim"

# Configs
# "${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}
alias config="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}.zshrc" \
      c-bspwm="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/bspwm/bspwmrc" \
      c-sxhkd="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/sxhkd/sxhkdrc" \
      c-nvim-o="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/.config/nvim/lua/options.lua" \
      c-nvim-b="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/.config/nvim/lua/bindings.lua" \
      c-zathura="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/zathura/zathurarc" \
      c-dunst="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/dunst/dunstrc" \
      c-alacritty="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/alacritty/alacritty.yml" \
      c-tint="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/tint2/tint2rc" \
      c-xres="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME"}/.Xresources" \
      c-picom="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME"}/picom.conf" \
      c-kitty="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/kitty/kitty.conf" \
      c-i3="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/i3/config" \
      c-player="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/ncmpcpp/config" \
      c-mpd="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/mpd/mpd.conf" \
      c-poly-bars="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/polybar/config" \
      c-poly-modules="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/polybar/modules.ini" \
      c-poly-colors="${EDITOR:-"$(command -v nvim)"} ${XDG_CONFIG_HOME:-"$HOME/.config"}/polybar/colors.ini" 

alias gotoProjects="cd ~/Documents/Projects/"
alias gotoDownloads="cd ~/Downloads/"
alias gotoDocuments="cd ~/Documents/"
alias gotoPictures="cd ~/Pictures/"
alias gotoRustPrjs="cd ~/Documents/Projects/rust-projects/"
alias gotoBashPrjs="cd ~/Documents/Projects/script-projects/"
alias gotoWallpapers="cd ~/Pictures/wallpapers"
alias gotoVimPrjs="cd ~/Documents/Projects/vim-projects/"

# Tmux
alias t-attach='tmux attach -t' \
    t-attach-d='tmux attach -d -t' \
    t-new='tmux new-session -s' \
    t-list='tmux list-sessions' \
    t-kill-s='tmux kill-server' \
    t-kill-ss='tmux kill-session -t'

# Network
alias net-show='nmcli connection show' \
      net-dev='nmcli device' \
      net-up='nmcli connection up uuid' \
      net-deco='nmcli device disconnect'

alias ka="killall $@" \
      sudo="su "$@"" \
      ssu="ssu "$@"" \
      free="free -hm" \
      ssh="ssh -F ${XDG_CONFIG_HOME:-"$HOME/.config"}/ssh/config" \
      so="source" \
      k="pkill -x -9" \
      q="exit" \
      c="clear" \
      f="find" \
      tree="tree -aC" 

# ---| Functions N Stuff |--- #

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

# Show top 21 Commands used (thanks totoro
toppy() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n 21
}

file_amount() {
    ls -l | wc -l
}

# ls with preferred arguments
ls() {
	command ls --group-directories-first --color=auto -F1 "$@"
}

# cd and ls after
cd() {
	builtin cd "$@" && command ls --group-directories-first --color=auto -F
}

# recompile completion and reload zsh
src() {
	autoload -U zrecompile
	rm -rf "$compfile"*
	compinit -u -d "$compfile"
	zrecompile -p "$compfile"
	exec zsh
}

node-project() {
  git init
  npx license $(npm get init.license) -o "$(npm get init.author.name)" > LICENSE
  npx gitignore node
  npx covgen "$(npm get init.author.email)"
  npm init -y
  git add -A
  git commit -m "Initial commit"
}

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

# Firefox plz
export BROWSER=/usr/bin/firefox

# Some Rust Lang thing idk
export PATH="$HOME/.cargo/bin:$PATH"

# Lang
export LANG=en_US.UTF-8

# Starship export
export STARSHIP_CONFIG=~/.config/starship/starship.toml

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


# History
zshAddHistory() {
	whence ${${(z)1}[1]} >| /dev/null || return 1
}

# bind keys not in terminfo
bindkey -- '^R'    history-incremental-pattern-search-backward
bindkey -- '^F'    history-incremental-pattern-search-foward/
bindkey -- '^P'    up-history
bindkey -- '^N'    down-history
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
zstyle ':completion:*:options' auto-description '%d'
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

# For tty
if [ "$TERM" = "linux" ] ; then
    echo -en "\e]P0232323"
fi

# initialize completion
compinit -u -d "$compfile"

eval "$(starship init zsh)"

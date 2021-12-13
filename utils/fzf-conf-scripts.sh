

# Settings from https://youtu.be/qgG5Jhi_Els?t=404
FD_OPTIONS="--follow --exclude .git --exclude node_modules"

export FZF_DEFAULT_OPTS="--inline-info --ansi --multi --layout=reverse --height=80% --exact"
# export FZF_DEFAULT_OPTS="--no-mouse -height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) @> /dev/null"

# export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'

# bat doesn't work with any input other than the list of files
# ps -ef | fzf
# seq 100 | fzf
# history | fzf


export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
# export FZF_ALT_C_COMMAND="fd -t d . $HOME"
# export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude \".git\" . $HOME"

export BAT_PAGER="less -R"
# export BAT_THEME="ansi-dark"
# export FZF_PREVIEW_PREVIEW_BAT_THEME="Nord"

# Error running '/opt/homebrew/Cellar/fzf/0.28.0/bin/fzf'  '--multi' '--prompt' '~/Documents/' 'plugin' --expect=ctrl-v,ctrl-x,ctrl-t --no-height > /var/folders/8x/w98pxwks1z1cdqjgkj_636r00000gn/T/nvim15q1FX/6


alias fzc="find * | fzf -m --preview 'bat --style=changes --color=always --line-range=:500 {}'"
# export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'

# Nice styling example:
# fzf --height 40% --layout reverse --info inline --border \
#     --preview 'file {}' --preview-window up,1,border-horizontal \
#     --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'



# _fzf_compgen_path() {
#   fd --hidden --follow --exclude ".git" . "$1"
# }

# Use fd to generate the list for directory completion
# _fzf_compgen_dir() {
#   fd --type d --hidden --follow --exclude ".git" . "$1"
# }

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -400' ;;
    ls)           fzf "$@" --preview 'tree -C {} | head -400' ;;
    vim)          fzf "$@" --preview 'bat --style=changes --color=always --line-range=:500 {}' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

# ─   Fzf custom functions                               ■

# fd - cd to selected directory
fzffd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

# chromehistory - browse chrome history
chromehistory() {
  local cols sep google_history open
  cols=$(( COLUMNS / 3 ))
  sep='{::}'

  if [ "$(uname)" = "Darwin" ]; then
    google_history="$HOME/Library/Application Support/Google/Chrome/Default/History"
    open=open
  else
    google_history="$HOME/.config/google-chrome/Default/History"
    open=xdg-open
  fi
  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open > /dev/null 2> /dev/null
}

# bookmarks - browse chrome bookmarks
bookmarks () {
     bookmarks_path=~/Library/Application\ Support/Google/Chrome/Default/Bookmarks

     jq_script='
        def ancestors: while(. | length >= 2; del(.[-1,-2]));
        . as $in | paths(.url?) as $key | $in | getpath($key) | {name,url, path: [$key[0:-2] | ancestors as $a | $in | getpath($a) | .name?] | reverse | join("/") } | .path + "/" + .name + "\t" + .url'

    jq -r "$jq_script" < "$bookmarks_path" \
        | sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' \
        | fzf --ansi \
        | cut -d$'\t' -f2 \
        | xargs open
}


processesupdate() {
  (date; ps -ef) |
    fzf --bind='ctrl-r:reload(date; ps -ef)' \
    --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
    --preview='echo {}' --preview-window=down,3,wrap \
    --layout=reverse --height=80% | awk '{print $2}' | xargs kill -9
  }

fzfbindings() {
  find * | fzf --prompt 'All> ' \
    --header 'CTRL-D: Directories / CTRL-F: Files' \
    --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
    --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)'
}

# fzf --bind 'ctrl-d:reload(find . -type d),ctrl-f:reload(find . -type f)'

# fshow - git commit browser
fzfgitcommits() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fcoc_preview - checkout git commit with previews
fzfcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow_preview - git commit browser with previews
fzfshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

# Install or open the webpage for the selected application 
# using brew cask search as input source
# and display a info quickview window for the currently marked application
# not working preperly:
_fzfbrewinstall() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
}

# this works fine, you just need to c-[ /c-c to cd to the currently active folder. it's just not very ergonomic(?)
function fzfcd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && /bin/ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                /bin/ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}


# Multiline display in preview area.
# cat > /tmp/source << EOF
# zfs-initramfs/focal-updates 0.8.3-1ubuntu12.4 amd64
#   OpenZFS root filesystem capabilities for Linux - initramfs
#
# zfs-test/focal-updates 0.8.3-1ubuntu12.4 amd64
#   OpenZFS test infrastructure and support scripts
#
# zfs-zed/focal-updates 0.8.3-1ubuntu12.4 amd64
#   OpenZFS Event Daemon
#
# zfsutils-linux/focal-updates 0.8.3-1ubuntu12.4 amd64
#   command-line tools to manage OpenZFS filesystems
# EOF
#
# perl -pe 'BEGIN{undef $/;} s/\n\n/\x0/g; s/\n$//g' /tmp/source |
#   fzf --height 50% --reverse --read0 --no-hscroll --preview 'echo {}' --preview-window up:2 |
#   awk 'NR == 1 {print $1}'



# ─^                                                     ▲


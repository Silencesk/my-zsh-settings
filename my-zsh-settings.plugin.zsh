###############################################################################
# helper functions
###############################################################################

logAndRun() {
    echo "$@"
    "$@"
}

###############################################################################
# Env settings
###############################################################################

export EDITOR=vim
export LANG=en_US.UTF-8
export LC_CTYPE=UTF-8
export LESS="${LESS}iXF"
export WINEDEBUG=-all

# append brew man
export MANPATH="$(cat $ZSH_CACHE_DIR/man_path_cache):$MANPATH"

# Calibre utils, brew texinfo
export PATH="/usr/local/opt/texinfo/bin:$PATH:/Applications/calibre.app/Contents/MacOS"

###############################################################################
# Shell Imporvement
###############################################################################

### shell settings ###

# set color theme of ls in terminal to GNU/Linux Style
# use `which gdircolors` instead of `brew list | grep coreutils -q` for speedup
which gdircolors &> /dev/null && {
    alias ls='ls -F --show-control-chars --color=auto'
    eval `gdircolors -b <(gdircolors --print-database)`
}

# Use Ctrl-Z to switch back to backgroud proccess(eg: Vim)
# https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# how to make ctrl+p behave exactly like up arrow in zsh?
# http://superuser.com/questions/583583
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# Ubuntu’s command-not-found equivalent for Homebrew on macOS
# https://github.com/Homebrew/homebrew-command-not-found
if [ -e "$ZSH/cache/homebrew-command-not-found-init" ]; then
    eval "$(cat "$ZSH/cache/homebrew-command-not-found-init")"

    (( $(date -r "$ZSH/cache/homebrew-command-not-found-init" +%s) < $(date -d 'now - 7 days' +%s) )) && (
        touch "$ZSH/cache/homebrew-command-not-found-init"
        # backgroud proccess that run in subshell will not output job control message
        brew command-not-found-init > "$ZSH/cache/homebrew-command-not-found-init" &
    )
else
    # backgroud proccess that run in subshell will not output job control message
    ( brew command-not-found-init > "$ZSH/cache/homebrew-command-not-found-init" & )
fi

# open file with default application
for ext in doc{,x} ppt{,x} xls{,x} key pdf png jp{,e}g htm{,l} m{,k}d markdown asta txt xml xmind java c{,pp} .h{,pp}; do
    alias -s $ext=open
done

### shell alias ###

# core utils

alias du='du -h'
alias df='df -h'
alias ll='ls -lh'
alias lls='ll -Sr'
alias llt='ll -tr'
alias tailf='tail -f'
alias D=colordiff
compdef coat=cat

alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn,.cvs,bzr,CVS,target,build,_site,.idea,Pods,taobao-tomcat} --exclude=\*.{ipr,iml,iws,jar,war,zip}'
export GREP_COLOR='07;31'

# show type -a and which -a info together, very convenient!
ta() {
    echo "type -a:\n"
    # type buildin command can output which file the function is definded. COOL!
    type -a "$@"
    echo "\nwhich -a:\n"
    # which buildin command can output the function implementation. COOL!
    which -a "$@"
}
# Tab completion for aliased sub commands in zsh: alias gco='git checkout'
# Reload auto completion
#   zsh -f && autoload -Uz compinit && compinit
# http://stackoverflow.com/questions/14307086
compdef ta=type

# Remove duplicate entries in a file without sorting
# http://www.commandlinefu.com/commands/view/4389
alias uq="awk '!x[\$0]++'"

# ReStart SHell
# How to reset a shell environment? https://unix.stackexchange.com/questions/14885
rsh() {
    exec env -i \
        TERM=$TERM TERM_PROGRAM=$TERM_PROGRAM TERM_PROGRAM_VERSION=$TERM_PROGRAM_VERSION TERM_SESSION_ID=$TERM_SESSION_ID \
        ITERM_PROFILE=$ITERM_PROFILE ITERM_SESSION_ID=$ITERM_SESSION_ID \
        TMUX=$TMUX TMUX_PANE=$TMUX_PANE \
        XPC_FLAGS=$XPC_FLAGS XPC_SERVICE_NAME=$XPC_SERVICE_NAME \
        __CF_USER_TEXT_ENCODING=$__CF_USER_TEXT_ENCODING \
        Apple_PubSub_Socket_Render=$Apple_PubSub_Socket_Render \
        SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
        USER=$USER LOGNAME=$LOGNAME SHELL=$SHELL \
        TMPDIR=$TMPDIR DISPLAY=$DISPLAY COLORFGBG=$COLORFGBG \
        "$@" \
        zsh --login -i
}

### zsh/oh-my-zsh redefinition ###

# improve alias d of oh-my-zsh: colorful lines, near index number and dir name(more convenient for human eyes)
alias d="dirs -v | head | tr '\t' ' ' | coat"

# editor

alias v=nvim
alias nv=vim
alias vi=v

alias 'v-'='v -'
alias vv='col -b | v -'
alias vw='v -R'
alias vd='v -d'

alias gv=gvim
alias 'gv-'='gv -'
alias gvv='col -b | gv -'
alias gvw='gv -R'
alias gvd='gv -d'
alias note='(cd ~/notes; gv)'

alias a='atom'
alias a.='atom .'
alias a..='atom ..'
alias vc='open -a /Applications/Visual\ Studio\ Code.app'
alias vc.='open -a /Applications/Visual\ Studio\ Code.app .'
alias vc..='open -a /Applications/Visual\ Studio\ Code.app ..'

# mac utils

alias o=open
alias o.='open .'
alias o..='open ..'

alias b=brew
alias bi='brew info'
alias bh='brew home'
alias bls='brew list'

alias bin='brew install'
alias bui='brew uninstall'
alias bri='brew reinstall'
alias bs='brew search'

# docker

alias dk=docker
alias dkc='docker create'

alias dkr='docker run'
alias dkrr='docker run --rm'

alias dkri='docker run -i -t'
alias dkrri='docker run --rm -i -t'

alias dkrd='docker run -d'
alias dkrrd='docker run --rm -d'

alias dkrm='docker rm'
alias dkrmi='docker rmi'

alias dks='docker start'
alias dksi='docker start -i'
alias dkrs='docker restart'
alias dkstop='docker stop'

alias dki='docker inspect'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dktop='docker top'

alias dke='docker exec'
alias dkei='docker exec -i -t'
alias dkl='docker logs'
alias dklf='docker logs -f'

alias dkimg='docker images'
alias dkp='docker pull'
alias dksh='docker search'

dkcleanimg() {
    local images="$(docker images | awk 'NR>1 && $2=="<none>" {print $3}')"
    [ -z "$images" ] && {
        echo "No images need to cleanup!"
        return
    }

    echo "$images" | xargs --no-run-if-empty docker rmi
}

dkupimg() {
    local images="$(docker images | awk 'NR>1 && $2="latest"{print $1}')"
    [ -z "$images" ] && {
        echo "No images need to upgrade!"
        return
    }

    echo "$images" | sort -u | xargs --no-run-if-empty -n1 docker pull
}

# my utils

alias cap='c ap'
# print and copy full path of command bin
capw() {
    local arg
    for arg; do
        ap "$(which "$arg")" | c
    done
}

alias t=tmux
alias tma='exec tmux attach'

alias sl=sloccount
alias ts=trash

# speed up download
alias ax='axel -n8'
alias axl='axel -n16'

alias pc='proxychains4 -q'

lstcp() {
    lsof -n -P -iTCP ${1:+"-sTCP:$1"}
}

ilstcp() {
    local st
    select st in ESTABLISHED SYN_SENT SYN_RCDV LAST_ACK TIME_WAIT FIN_WAIT1 FIN_WAIT_2 CLOSE_WAIT CLOSING CLOSED LISTEN IDLE BOUND; do
        [ -n "$st" ] && {
            lstcp "$st"
            break
        }
    done
}

# List tcp listen port info(very useful on mac)
#
# inhibits the conversion so as to run faster
#   -P inhibits the conversion of port numbers to port names
#   -n inhibits the conversion of network numbers to host names
alias tcplisten='lstcp LISTEN'

# fpp is an awesome toolkit: https://github.com/facebook/PathPicker
## reduce exit time of fpp
alias fpp='SHELL=sh fpp'
alias p=fpp

# adjust indent for space 4
toc() {
    command doctoc --notitle "$@" && sed '/^<!-- START doctoc generated TOC/,/^<!-- END doctoc generated TOC/s/^( +)/\1\1/' -ri "$@"
}

# generate an image showing a mathematical formula, using the TeX language by Google Charts
# https://developers.google.com/chart/infographics/docs/formulas
fml() {
    local url=$(printf 'http://chart.googleapis.com/chart?cht=tx&chf=bg,s,00000000&chl=%s\n' $(urlencode "$1"))
    printf '<img src="%s" style="border:none;" alt="%s" />\n' "$url" "$1" | c
    # imgcat <(curl -s "$url")
    o $url
}

alias pt=pstree

alias otv=octave-cli
alias vzshrc='v ~/.zshrc'

###############################################################################
# Git
###############################################################################

# git diff

alias gd='git diff --ignore-space-change --ignore-space-at-eol --ignore-blank-lines'
alias gD='git diff'

alias gdc='gd --cached'
alias gDc='gD --cached'
alias gdh='gd HEAD'
alias gDh='gD HEAD'

alias gdorigin='gd origin/$(git_current_branch)'
alias gDorigin='gD origin/$(git_current_branch)'

function gds() {
    if [ $# -eq 0 ]; then
        2=HEAD
        1='HEAD^'
    elif [ $# -eq 1 ]; then
        2="$1"
        1="$1^"
    fi
    gd "$@" $__git_diff_ignore_options
}

function gDs() {
    if [ $# -eq 0 ]; then
        2=HEAD
        1='HEAD^'
    elif [ $# -eq 1 ]; then
        2="$1"
        1="$1^"
    fi
    gD "$@"
}

# git status

alias gssi='git status -s --ignored'
alias gsti='git status --ignored'
alias gs='git status -s' # I never use gs command but will mistype :)

# git log

alias gg='glog -20'

## git branch

alias __git_remove_bkp_rel_branches='sed -r "/->/b; /\/tags\//d; /\/releases\//d; /\/backups?\//d; /\/bkps?\//d"'
alias __git_output_local_branch='sed -r "/->/b; s#remotes/([^/]+)/(.*)#remotes/\1/\2 => \2#"'

__gbb() {
    # How can I get a list of git branches, ordered by most recent commit?
    #   http://stackoverflow.com/questions/5188320
    # --sort=-committerdate : sort branch by commit date in descending order
    # --sort=committerdate : sort branch by commit date in ascending order
    git branch --sort=committerdate "$@" | __git_remove_bkp_rel_branches | __git_output_local_branch
}

__gbB() {
    git branch --sort=committerdate "$@" | __git_remove_bkp_rel_branches
}

alias gbt='__gbb -a'
alias gbtr='__gbb --remote'
alias gbT='__gbB -a'
alias gbTr='__gbB --remote'

# How to list branches that contain a given commit?
# http://stackoverflow.com/questions/1419623
alias gbc='git branch --contains'
alias gbrc='git branch -r --contains'

alias gbd='git branch -d'
alias gbD='git branch -D'
gbdd() {
    git branch -d "$@" && git push -d origin "$@"
}
gbDD() {
    git branch -D "$@" && git push -d origin "$@"
}

# git add

alias ga.='git add .'
alias ga..='git add ..'

# git checkout

alias gcoh='git checkout HEAD'
# checkout previous branch
alias gcop='git checkout -'
# checkout most recent modified branch
alias gcor="git checkout \$(gbt | awk -rF' +=> +' '/=>/{print \$2}' | tail -1)"

# git reset/rebase

alias grb='git rebase'
alias grs='git reset'
alias grshd='git reset --hard'
alias grsorigin='git reset --hard origin/$(git_current_branch)'

# git clone

alias gcn='git clone'
alias gcnr='git clone --recurse-submodules'

# git commit

alias gam='git commit --amend -v'
alias gamno='git commit --amend --no-edit'

# git push

alias gpf='git push -f'

# compound git command

alias ga.c='git add . && git commit -v'
alias ga.m='git add . && git commit --amend -v'
alias ga.mno='git add . && git commit --amend --no-edit'

alias ga.cp='git add . && git commit -v && git push'

alias gampf='git commit --amend --no-edit && git push -f'
alias ga.cpf='git add . && git commit -v && git push -f'
alias ga.mpf='git add . && git commit --amend --no-edit && git push -f'

# misc
gbw() {
    # git browse
    local url="${1:-$(git remote get-url origin)}"
    if ! [[ "$url" =~ '^http' ]]; then
        url=$(echo "$url" | sed 's#^git@#http://#; s#http://github.com#https://github.com#; s#(\.com|\.org):#\1/#; s#\.git$##' -r)
    fi

    echo "open $url"
    open "$url"
}

heaveyOpenFileByApp() {
    [ $# -eq 0 ] && {
        echo "at least 1 app args" 1>&2
        exit 1
    }

    readonly app="$1"
    shift
    [ $# -eq 0 ] && readonly files=(.) || readonly files=("$@")

    local -a absolute_files
    local f
    for f in "${files[@]}"; do
        absolute_files=("${absolute_files[@]}" $(readlink -f "$f"))
    done

    logAndRun open --new -a "$app" --args "${absolute_files[@]}"
}

# Smart Git
alias sg='heaveyOpenFileByApp /Applications/SmartGit.app'
# Smart Diff
alias sd='heaveyOpenFileByApp /Applications/SmartSynchronize.app'

## URL shower/switcher

# show swithed git repo addr(git <=> http)
shg() {
    local url="${1:-$(git remote get-url origin)}"
    if [ -z "$url" ]; then
        echo "No arguement and Not a git repository!"
        return 1
    fi

    if [[ "$url" =~ '^http' ]]; then
        echo "$url" | sed 's#^https?://#git@#; s#(\.com|\.org)/#\1:#; s#(\.git)?$#\.git#' -r | c
    else
        echo "$url" | sed 's#^git@#http://#; s#http://github.com#https://github.com#; s#(\.com|\.org):#\1/#; s#\.git$##' -r | c
    fi
}
# show git repo addr http addr recursively
shgr() {
    local d
    for d in `find -iname .git -type d`; do
        (
            cd $d/..
            echo "$PWD : $(git remote get-url origin)"
        )
    done
}
# change git repo addr http addr recursively
chgr() {
    local d
    for d in `find -iname .git -type d`; do
        (
            cd $d/..
            echo "Found $PWD"
            local url=$(git remote get-url origin)
            [[ "$url" =~ '^http'  ]] && {
                local gitUrl=$(shg)
                echo "CHANGE $PWD : $url to $gitUrl"
                git remote set-url origin $gitUrl
            } || {
                echo -e "\tIgnore $PWD : $url"
            }
        )
    done
}

# git up
# https://github.com/msiemens/PyGitUp
#
# git pull has two problems:
#   It merges upstream changes by default, when it's really more polite to rebase over them, unless your collaborators enjoy a commit graph that looks like bedhead.
#   It only updates the branch you're currently on, which means git push will shout at you for being behind on branches you don't particularly care about right now.
# Solve them once and for all.
# alias gu='git-up'
alias gu='git pull --rebase --autostash'

# git up recursively
# Usage: gur [<dir1>  [<dir2> ...]]
gur() {
    local -a files
    [ $# -eq 0 ] && files=(.) || files=("$@")

    local -a failedDirs=()

    local f
    local d
    for f in "${files[@]}" ; do
        [ -d "$f" ] || {
            echo
            echo "================================================================================"
            echo "$f is not a directory, ignore and skip!!"
            continue
        }
        for d in `find $f -iname .git -type d`; do
            d="$(readlink -f "$d/..")"
            (
                cd $d && {
                    echo
                    echo "================================================================================"
                    echo -e "Update Git repo:\n\trepo path: $PWD\n\trepo url: $(git remote get-url origin)"
                    git-up
                }
            ) || failedDirs=( "${failedDirs[@]}" "$d")
        done
    done

    if [ "${#failedDirs[@]}" -gt 0 ]; then
        echo
        echo
        echo "================================================================================"
        echo "Failed dirs:"
        local idx=0
        for d in "${failedDirs[@]}"; do
            echo "    $((++idx)): $d"
        done
    fi
}


###############################################################################
# Java/JVM Languages
###############################################################################

swJavaNetProxy() {
    # How to check if a variable is set in Bash?
    # http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
    [ -z "${JAVA_OPTS_BEFORE_NET_PROXY+if_check_var_defined_will_got_output_or_nothing}" ] && {
        export JAVA_OPTS_BEFORE_NET_PROXY="$JAVA_OPTS"
        export JAVA_OPTS="$JAVA_OPTS -DproxySet=true -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=7070"
        echo "turn ON java net proxy!"
    } || {
        export JAVA_OPTS="$JAVA_OPTS_BEFORE_NET_PROXY"
        unset JAVA_OPTS_BEFORE_NET_PROXY
        echo "turn off java net proxy!"
    }
}

#export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
export JAVA6_HOME='/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home'
export JAVA7_HOME=$(echo /Library/Java/JavaVirtualMachines/jdk1.7.0_*.jdk/Contents/Home)
export JAVA8_HOME=$(echo /Library/Java/JavaVirtualMachines/jdk1.8.0_*.jdk/Contents/Home)
export JAVA9_HOME=$(echo /Library/Java/JavaVirtualMachines/jdk-9.*.jdk/Contents/Home)
# default JAVA_HOME
export JAVA0_HOME="$HOME/.jenv/candidates/java/current"

export JAVA_HOME="$JAVA0_HOME"

export JAVA_OPTS="${JAVA_OPTS:+$JAVA_OPTS }-Duser.language=en -Duser.country=US"
export MANPATH="$JAVA_HOME/man:$MANPATH"

# jenv is an awesome tool for managing parallel Versions of Java Development Kits!
# https://github.com/linux-china/jenv
[[ -s "$HOME/.jenv/bin/jenv-init.sh" ]] && ! type jenv > /dev/null &&
source "$HOME/.jenv/bin/jenv-init.sh" &&
source "$HOME/.jenv/commands/completion.sh"

# JAVA_HOME switcher
alias j6='export JAVA_HOME=$JAVA6_HOME'
alias j7='export JAVA_HOME=$JAVA7_HOME'
alias j8='export JAVA_HOME=$JAVA8_HOME'
alias j9='export JAVA_HOME=$JAVA9_HOME'
alias j0='export JAVA_HOME=$JAVA0_HOME'

alias scl='scala -Dscala.color -feature'

export JREBEL_HOME=$HOME/Applications/jrebel7.0.2

export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_HOME=$ANDROID_HOME
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools"

alias jad='jad -nonlb -space -ff -s java'

###############################################################################
# Maven
###############################################################################

export MAVEN_OPTS="${MAVEN_OPTS:+$MAVEN_OPTS }-Xmx512m -Duser.language=en -Duser.country=US"

alias mc='mvn clean'
alias mi='mvn install -Dmaven.test.skip -Dautoconf.skip -Dautoconfig.skip -Denv=release -Dscm.app.name=faked'
alias mio='mvn install -o -Dmaven.test.skip -Dautoconf.skip -Dautoconfig.skip -Denv=release -Dscm.app.name=faked'
alias mci='mvn clean && mvn install -Dmaven.test.skip -Dautoconf.skip -Dautoconfig.skip -Denv=release -Dscm.app.name=faked'
alias mcio='mvn clean && mvn install -o -Dmaven.test.skip -Dautoconf.skip -Dautoconfig.skip -Denv=release -Dscm.app.name=faked'
alias mcdeploy='mvn clean && mvn deploy -Dmaven.test.skip -Dautoconf.skip -Dautoconfig.skip -Denv=release'

alias mdt='mvn dependency:tree'
alias mds='mvn dependency:sources'
alias mdc='mvn dependency:copy-dependencies -DincludeScope=runtime'

alias mcv='mvn versions:display-dependency-updates versions:display-plugin-updates versions:display-property-updates'

# Update project version
muv() {
    [ $# -ne 1 ] && {
        echo "Only 1 argument for verson!"
        exit 1
    }
    mvn org.codehaus.mojo:versions-maven-plugin:2.4:set -DgenerateBackupPoms=false -DnewVersion="$1"
}

# create maven wrapper
# http://mvnrepository.com/artifact/io.takari/maven
mwrapper() {
    local run_mvn_version="$(mvn -v | awk '/^Apache Maven/ {print $3}')"

    local wrapper_mvn_version="${1:-$run_mvn_version}"
    # http://mvnrepository.com/artifact/io.takari/maven
    mvn -N io.takari:maven:0.5.0:wrapper -Dmaven="$wrapper_mvn_version"
}

###############################################################################
# Gradle
###############################################################################

#export GRADLE_OPTS="-Xmx1024m -Xms256m -XX:MaxPermSize=512m"
alias grd='gradle'

# shortcut for executing gradlew:
# find gradlew automatically and execute.
function grw() {
    local d="$PWD"
    while true; do
        [ "/" = "$d" ] && {
            echo "fail to find gradlew" 2>&1
            return 1
        }
        [ -f "$d/gradlew" ] && {
            break
        }
        d=`dirname "$d"`
    done

    [ $d != $PWD ] && echo "use gradle wrapper: $(realpath "$d" --relative-to="$PWD")/gradlew"
    "$d/gradlew" "$@"
}

alias grwb='grw build'
alias grwc='grw clean'
alias grwcb='grw clean build'
alias grwt='grw test'

alias grwf='grw --refresh-dependencies'
alias grwfb='grw --refresh-dependencies build'
alias grwfc='grw --refresh-dependencies clean'
alias grwfcb='grw --refresh-dependencies clean build'

alias grwd='grw -q dependencies'
alias grwdc='grw -q dependencies --configuration compile'
alias grwdr='grw -q dependencies --configuration runtime'
alias grwdtc='grw -q dependencies --configuration testCompile'

# kill all gradle deamon processes on mac
alias kgrdm="jps -l | awk '\$2==\"org.gradle.launcher.daemon.bootstrap.GradleDaemon\"{print \$1}' | xargs -r kill -9"
# show all gradle deamon processes on mac
alias sgrdm="jps -l | awk '\$2==\"org.gradle.launcher.daemon.bootstrap.GradleDaemon\"{print \$0}'"


###############################################################################
# Javascript
###############################################################################

# NVM: https://github.com/creationix/nvm
#
# NVM init is slowwwwww! about 1.2s on my machine!!
# manually activate when needed.
export PATH="$HOME/.nvm/versions/node/v8.1.2/bin:$PATH"
anvm() {
    export NVM_DIR="$HOME/.nvm"
    source "/usr/local/opt/nvm/nvm.sh"
    source <(npm completion)
}

###############################################################################
# Python
###############################################################################

ZSH_PIP_INDEXES='http://pypi.douban.com/simple/'

alias py='python'
alias ipy='ipython'

alias py3='echo use python instead! && false'
alias ipy3='echo use ipython instead! && false'
alias pip3='echo use pip instead! && false'

alias pyenv='python3 -m venv'

pipup() {
    pip list --outdated | awk 'NR>2{print $1}' | xargs pip install --upgrade
}

# Python Virtaul Env
pve() {
    echo "current VIRTUAL_ENV: $VIRTUAL_ENV"

    echo "select python virtual env to activate:"
    local venv
    select venv in `find $HOME/.virtualenv -maxdepth 1 -mindepth 1 -type d` \
                   `find $HOME/.pyenv -maxdepth 1 -mindepth 1 -type d` ; do
        [ -n "$venv" ] && {
            [ -n "$VIRTUAL_ENV" ] && deactivate
            source "$venv/bin/activate"
            break
        }
    done
}

relink_virtualenv() {
    # relink python 2
    (
        cd $HOME/.virtualenv
        find -type l -xtype l -delete
        local d
        for d in *; do
            virtualenv $d
        done
    )
    # relink python 3
    (
        cd $HOME/.pyenv
        find -type l -xtype l -delete
        local d
        for d in *; do
            python3 -m venv $d
        done
    )
}

# activate/deactivate anaconda3
aa() {
    declare -f deactivate > /dev/null && {
        echo "Activate anaconda3!"

        deactivate
        # append anaconda3 to PATH
        export PATH=$HOME/.anaconda3/bin:$PATH
    } || {
        echo "Deactivate anaconda3!"

        # remove anaconda3 from PATH
        export PATH="$(echo "$PATH" | sed 's/:/\n/g' | grep -Fv .anaconda3/bin | paste -s -d:)"
        source $HOME/.pyenv/default/bin/activate
    }
}

# activate anaconda3 python
export PATH=$HOME/.anaconda3/bin:$PATH

###############################################################################
# Go
###############################################################################

export GOPATH=$HOME/.gopath
export PATH=$PATH:$GOPATH/bin

###############################################################################
# Ruby
###############################################################################

source $HOME/.rvm/scripts/rvm

###############################################################################
# Erlang
###############################################################################

alias r2=rebar
alias r3=rebar3

# Run erlang MFA(Module-Function-Args) conveniently
erun() {
    if [ $# -lt 2 ]; then
        echo "Error: at least 2 args!"
        return 1
    fi
    erl -s "$@" -s init stop -noshell
}

# Run erlang one-line script conveniently
erline() {
    if [ $# -ne 1 ]; then
        echo "Error: Only need 1 arg!"
        return 1
    fi
    erl -eval "$1" -s init stop -noshell
}


###############################################################################
# Lisp
###############################################################################

CLISP_DOC=/usr/local/Cellar/clisp/2.49/share/doc/clisp/doc

alias schm='rlwrap -p 1\;32 -r -c -f $HOME/.scheme_completion.rlwrap scheme'

###############################################################################
# Prolog
###############################################################################

alias sp='swipl'
alias gpl='gprolog'
alias bp='$HOME/Applications/BProlog/bp'


###############################################################################
# JetBrains
###############################################################################

# JetBrains Toolbox: The right tool for the job — every time!
# https://www.jetbrains.com/toolbox/
JB_TOOL_HOME="$HOME/Library/Application Support/JetBrains/Toolbox/apps"

_jb_ide() {
    local ide="$1"
    shift
    (
        cd $JB_TOOL_HOME
        local -a candidates=("$ide"/*/*/*.app)
        cd -
        local count="$#candidates[@]"
        if (( count == 0 )); then
            echo "No candidates!"
        elif (( count == 1 )); then
            logAndRun open -a "$JB_TOOL_HOME/$candidates" "$@"
        else
            echo "Find multi candidates!"
            select ide in "$candidates[@]" ; do
                [ -n "$ide" ] && {
                    [ -n "$ide" ] && logAndRun open -a "$JB_TOOL_HOME/$ide" "$@"
                    break
                }
            done
        fi
    )
}

#alias idea='open -a /Applications/IntelliJ\ IDEA.app'
alias idea='_jb_ide IDEA-U'
#alias apcd='open -a /Applications/AppCode.app'
alias apc='_jb_ide AppCode'
alias ads='open -a /Applications/Android\ Studio*.app'

#alias pyc='open -a /Applications/PyCharm.app'
alias pyc='_jb_ide PyCharm-P'
alias wbs='_jb_ide WebStorm'
alias rbm='_jb_ide RubyMine'

alias cln='_jb_ide CLion'
alias gol='_jb_ide Gogland'
alias rdr='_jb_ide Rider'

alias dtg='_jb_ide datagrip'
alias mps='_jb_ide MPS'

jb() {
    (
        cd $JB_TOOL_HOME
        local -a candidates=(*/*/*/*.app)
        cd -
        select ide in "$candidates[@]" ; do
            [ -n "$ide" ] && {
                [ -n "$ide" ] && logAndRun open -a "$JB_TOOL_HOME/$ide" "$@"
                break
            }
        done
    )
}

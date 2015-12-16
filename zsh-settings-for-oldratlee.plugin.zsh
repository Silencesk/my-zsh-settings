export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"
#export GRADLE_OPTS="-Xmx1024m -Xms256m -XX:MaxPermSize=512m"
export SVN_EDITOR=vim
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_HOME=$ANDROID_HOME
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle

CLISP_DOC=/usr/local/Cellar/clisp/2.49/share/doc/clisp/doc

if brew list | grep coreutils > /dev/null ; then
    alias ls='ls -F --show-control-chars --color=auto'
    eval `gdircolors -b <(gdircolors --print-database)`
fi

####################################
# My Config
####################################

export LESS="${LESS}i"

alias wa='which -a'
alias ta='type -a'
alias du='du -h'
alias df='df -h'
alias ll='ls -lh'
alias tailf='tail -f'
alias grep='grep --color=auto --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=target --exclude-dir=.idea'
#alias grep='grep --color=auto --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=target --exclude-dir=.idea --exclude=\*.jar --exclude=\*.ipr --exclude=\*.iml --exclude=\*.iws'
alias diff=colordiff

alias a='atom'
alias py='python'
alias py3='python3'
alias ipy='ipython'
alias ipy3='ipython3'

alias gpl='gprolog'
alias sp='/Applications/SWI-Prolog.app/Contents/MacOS/swipl'
alias bp='/Users/jerry/ProgFiles/BProlog/bp'
alias schm='rlwrap -p 1\;32 -r -c -f $HOME/.scheme_completion.rlwrap scheme'
alias srepl='scala -nc -Dscala.color'

# --daemon
alias grd='gradle'
function grw() {
    local d="$PWD"
    while true; do
        [ "/" = "$d" ] && {
            echo "fail to find gradlew" 2>&1
            return 1
        }
        [ -f "$d/gradlew" ] && {
            d=`dirname "$d"`
            break
        }
    done

    [ $d != $PWD ] && echo "use gradle wrapper: $(realpath "$d" --relative-to="$PWD")/gradlew"
    "$d/gradlew" "$@"
}
alias grwf='grw --refresh-dependencies'
alias grwb='grw build'
alias grwfb='grw --refresh-dependencies build'
alias grwc='grw clean'
alias grwfc='grw --refresh-dependencies clean'
alias grwcb='grw clean build'
alias grwfcb='grw --refresh-dependencies clean build'

alias grwt='grw test'
alias grwd='grw -q dependencies'
alias grwdc='grw -q dependencies --configuration compile'
alias grwdr='grw -q dependencies --configuration runtime'
alias grwdtc='grw -q dependencies --configuration testCompile'

alias kgrdm="jps -l | awk '\$2==\"org.gradle.launcher.daemon.bootstrap.GradleDaemon\"{print \$1}' | xargs -r kill -9"
alias sgrdm="jps -l | awk '\$2==\"org.gradle.launcher.daemon.bootstrap.GradleDaemon\"{print \$0}'"

alias ga.='git add .'
alias ga..='git add ..'
alias gdc='git diff --cached'
alias grb='git rebase'
alias gcoh='git checkout HEAD'
alias grs='git reset'
alias grsh='git reset HEAD'
alias grshard='git reset --hard'
alias gssi='git status -s --ignored'
alias gsti='git status --ignored'
alias glog5='glog -5'
alias glg5='glg -5'
alias gam='git commit --amend'
alias gamno='git commit --amend --no-edit'
alias gpf='git push -f'
alias gampf='git commit --amend --no-edit && git push -f'

alias d="dirs -v | head | tr '\t' ' ' | colines"

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1])"'

alias o=open
alias cap='c ap'
alias vi=vim
alias sl='open -a /Applications/Sublime\ Text\ 2.app'

alias idea='open -a /Applications/IntelliJ\ IDEA\ 15.app'
alias ads='open -a /Applications/Android\ Studio.app'
alias adsp='open -a /Applications/AndroidStudioPreview.app'
alias pych='open -a /Applications/PyCharm.app'
alias apcd='open -a /Applications/AppCode.app'
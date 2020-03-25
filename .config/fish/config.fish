# Fish config

set -g PKG_CONFIG_PATH /usr/lib/pkgconfig

# bobthefish

set -g theme_display_date no
set -g theme_nerd_fonts yes

# consts

set GRADLE_HOME /opt/gradle/gradle-5.0/bin
set CARGO_HOME /home/q/.cargo/bin
set ECLIPSE_HOME /home/q/tools/eclipse

# path

set PATH $PATH $CARGO_HOME
set PATH $PATH $GRADLE_HOME
set PATH $PATH $ECLIPSE_HOME

# alias

alias fd "fdfind"

# abbr

abbr c clear
abbr y yarn
abbr f fuck
abbr t tree
abbr v nvim
abbr s sudo
abbr ka sudo killall -9
abbr apt sudo apt

## abbr git

abbr g git
abbr gs git status -s -M -b
abbr gl "git log --decorate --pretty=format:'%C(bold blue)%h%C(reset) %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)[%cn]%C(reset)%C(bold yellow)%d%C(reset) %s'"
abbr glg "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''           %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
abbr gc git commit -m
abbr gci git commit -m
abbr gco git checkout
abbr ga git add
abbr gau git add -u
abbr gal git add --all
abbr gph git push
abbr gpl git pull
abbr grb git rebase

## abbr docker

abbr d docker
abbr drm docker rm
abbr drmi docker rmi
abbr dcl docker container list
abbr dcla docker container list -a
abbr dc docker-compose

## abbr vpn

abbr vpn sudo ~/tools/hma-linux/hma-vpn.sh -c ~/tools/hma-linux/credentials.txt -p tcp Paris

## abbr ls

abbr ls exa
abbr la exa -a
abbr ll exa -la --git

# opam configuration
source /home/q/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

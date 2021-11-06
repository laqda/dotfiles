# Fish config

set -g PKG_CONFIG_PATH /usr/lib/pkgconfig

# bobthefish

set -g theme_display_date no
set -g theme_nerd_fonts yes

# consts

set GRADLE_HOME /opt/gradle/gradle-5.0/bin
set MAVEN_HOME /home/q/tools/apache-maven-3.6.3/bin
set CARGO_HOME /home/q/.cargo/bin
set ECLIPSE_HOME /home/q/tools/eclipse
set GRAALVM_HOME /home/q/tools/graalvm-ce-java11-19.3.1/
set HELM_HOME /home/q/tools/helm/

# path

set PATH $PATH $CARGO_HOME
set PATH $PATH $GRADLE_HOME
set PATH $PATH $MAVEN_HOME
set PATH $PATH $ECLIPSE_HOME
set PATH $PATH $GRAALVM_HOME/bin
set PATH $PATH $HELM_HOME

# alias

alias fd "fdfind"

# abbr

abbr c clear
abbr y yarn
abbr f fuck
abbr t tree
abbr v nvim
abbr nv nvim
abbr s sudo
abbr ka sudo killall -9
abbr h helm

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
abbr dcsa docker container stop (docker container list -q)
abbr dc docker-compose

## abbr kubectl

abbr k kubectl
abbr kg kubectl get
abbr kga kubectl get all
abbr kgaa kubectl get all --all-namespaces
abbr kgp kubectl get pods
abbr kgpa kubectl get pods --all-namespaces
abbr kgs kubectl get services
abbr kgd kubectl get deploy
abbr kdp kubectl delete pods
abbr kds kubectl delete services
abbr kdd kubectl delete deploy
abbr kl kubectl logs -f
abbr kt kubectl top
abbr ktp kubectl top pods
abbr ktpa kubectl top pods --all-namespaces

## abbr vpn

abbr vpn sudo ~/tools/hma-linux/hma-vpn.sh -c ~/tools/hma-linux/credentials.txt -p tcp Paris

## abbr ls

abbr ls exa
abbr la exa -a
abbr ll exa -la --git

# opam configuration
source /home/q/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# link docker and minikube registries
# eval (minikube -p minikube docker-env)
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

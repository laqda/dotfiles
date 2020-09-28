# Path to your oh-my-zsh installation.
export ZSH="/home/q/.oh-my-zsh"

# ---------------------------------------------------------------------------------------------------
# HISTORY
# ---------------------------------------------------------------------------------------------------

unsetopt share_history

# ---------------------------------------------------------------------------------------------------
# ALLOW BLOCK COMMENTS
# ---------------------------------------------------------------------------------------------------

alias BEGINCOMMENT="if [ ]; then"
alias ENDCOMMENT="fi"

# ---------------------------------------------------------------------------------------------------
# THEME
# ---------------------------------------------------------------------------------------------------

ZSH_THEME="custom"

AGNOSTER_PROMPT_SEGMENTS=(
#    prompt_status
#    prompt_context
#    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
)

# ---------------------------------------------------------------------------------------------------
# PLUGINS
# ---------------------------------------------------------------------------------------------------

plugins=(
	cargo
	command-not-found
	z 
	zsh-autosuggestions
#	git
	zsh-abbr
	history-substring-search
	zsh-syntax-highlighting
	safe-paste
	fzf-tab
)

source $ZSH/oh-my-zsh.sh

# ---------------------------------------------------------------------------------------------------
# SUGGESTIONS
# ---------------------------------------------------------------------------------------------------

ZSH_AUTOSUGGEST_USE_ASYNC="true"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt MENU_COMPLETE # select first suggestion, fish-like

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999"

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")';

# ---------------------------------------------------------------------------------------------------
# FZF
# ---------------------------------------------------------------------------------------------------

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color pointer:#fccf03
--color gutter:#000000
--color hl:#fccf03
--color hl+:#fdd835
--color bg+:#353945
'
#export FZF_DEFAULT_COMMAND='fd --type f' # ignore .gitignore files

# ---------------------------------------------------------------------------------------------------
# BAT
# ---------------------------------------------------------------------------------------------------

export BAT_PAGER="less -RF" # allow wheel scrolling

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES
# ---------------------------------------------------------------------------------------------------

ABBR_QUIET=1

alias fd="fdfind"

abbr -S c="clear"
abbr -S y="yarn"
abbr -S t="tree"
abbr -S v="nvim"
abbr -S nv="nvim"
abbr -S s="sudo"
abbr -S ka="sudo killall -9"
abbr -S -f w="watch -c -n 1 -t"

alias untar='tar -zxvf '

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES | COMMON
# ---------------------------------------------------------------------------------------------------

function common_DeleteFirstLine { tail -n +2 }
function common_OnlyFirstLine {	head -n 1 }

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES | LS
# ---------------------------------------------------------------------------------------------------

abbr -S ls="exa"
abbr -S la="exa -a"
abbr -S ll="exa -la --git"

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES | GIT
# ---------------------------------------------------------------------------------------------------

abbr -S g="git"
abbr -S --force gs="git status -s -M -b"
alias gl="git log --decorate --pretty=format:'%C(bold blue)%h%C(reset) %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(dim white)[%cn]%C(reset)%C(bold yellow)%d%C(reset) %s'"
abbr -S glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''           %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
abbr -S gc="git commit -m"
abbr -S gci="git commit -m"
abbr -S gco="git checkout $(g:sb)"
abbr -S gcob="git branch | fzf | xargs git checkout"
abbr -S ga="git add"
abbr -S gau="git add -u"
abbr -S gal="git add --all"
abbr -S gph="git push"
abbr -S gpl="git pull"
abbr -S grb="git rebase"

alias g:sb="git branch -l | fzf | sed -e 's/^\** *//g'"

function gd {


	local commits;
	commits=$(gl --reverse)


	local first_commit;
	first_commit=$(echo "$commits" | fzf --ansi --tac +s +m -e --reverse)
	
	# select second commit
	# select files
}

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES | DOCKER
# ---------------------------------------------------------------------------------------------------

abbr -S -f d="docker"
abbr -S -f dc="docker container"
abbr -S -f di="docker image"
abbr -S -f din="docker inspect"
abbr -S -f de="docker exec"
abbr -S -f dk="docker kill"
abbr -S -f dps="docker ps"

# -----------------------------------------
# images
# -----------------------------------------

function docker_images_TitleLine { docker images | common_OnlyFirstLine }
function docker_images_LineToId { awk "{print \$3}" }

# di_tag <id>
#
# get the pair (name:tag) of a docker image
#
# Arguments
#	id	id of a docker image
#
function di_tag {
	readonly port=${1:?"The image's ID must be specified."}

	local inspect_json; # separate declaration from affectation to access the exist status
	inspect_json=$(docker inspect $1)

	if [ $? -ne 0 ]; then return; fi  # exit if failed

	# use 'cat <<<' to handle long lines
	cat <<< $inspect_json \
	| jq --raw-output '.[0].RepoTags[0]'	
}

# sdi [OPTIONS]
#
# launch a fuzzy-finder on docker images
#
# Arguments
#	OPTIONS added to the 'docker container ls' command
#
# Shortcuts
#	enter	id
#	ctrl-t	tag (from di_tag)
#
function sdi {
	local title=$'Press [enter] for ID, [ctrl-t] for Name:Tag. Use [space] to select multiple entries.\n\n'
	title+=$(docker_images_TitleLine)
	
	local result; # separate declaration from affectation to access the exist status
	result=$(docker images $@ \
	| common_DeleteFirstLine \
	| fzf --multi --reverse \
		--header $title \
		--bind "space:toggle" \
		--bind "enter:execute(echo \"ID\")+accept" \
		--bind "ctrl-t:execute(echo \"TAG\")+accept" \
	)

	if [ $? -ne 0 ]; then return; fi # exit if fzf failed (or ctrl-c)

	local mode=$(echo $result | common_OnlyFirstLine) # fzf prints the mode on the first line
	local data=$(echo $result | common_DeleteFirstLine) # fzf prints the line(s) selected after the mode

	
	data=$(cat <<< $data | docker_images_LineToId) # only keep ids

	# get the operation
	case $mode in
		ID)
		;;
		TAG)
			local tmp=$''
			cat <<< $data \
			| while read -r id; do
				tmp+=$(di_tag $id);
				tmp+=$'\n'
			done;

			data=$tmp
		;;
	esac
	
	# tr replaces new lines by spaces
	# sed replaces the last space by a new line
	echo $data  \
	| tr '\n' ' ' \
	| sed '$s/ $/\n/'
}

# drmi [ids]
#
# docker rmi on parameter ids if present, else launch 'sdi' to select image(s)
# 
# Arguments
#	ids	id(s) or name(s) of docker image(s)
#
function drmi {
	if [ $# -eq 0 ]; then # if no arg
		docker rmi $(sdi)
	else
		docker rmi $@
	fi
}

# drmif [ids]
#
# docker rmi -f on parameter ids if present, else launch 'sdi' to select image(s)
# 
# Arguments
#	ids	id(s) or name(s) of docker image(s)
#
function drmi {
	if [ $# -eq 0 ]; then # if no arg
		docker rmi -f $(sdi)
	else
		docker rmi -f $@
	fi
}

# -----------------------------------------
# containers
# -----------------------------------------

function docker_containers_TitleLine { docker container ls | common_OnlyFirstLine }
function docker_containers_LineToId { awk "{print \$1}" }

# dc_image <id>
#
# get the id of the base image of a docker container
#
# Arguments
#	id	id or name of a docker container
#
function dc_image {
	readonly port=${1:?"The container's ID must be specified."}

	local inspect_json; # separate declaration from affectation to access the exist status
	inspect_json=$(docker inspect $1)

	if [ $? -ne 0 ]; then return; fi  # exit if failed

	# use 'cat <<<' to handle long lines
	# removes the 'sha256:' in front of the id
	cat <<< $inspect_json \
	| jq --raw-output '.[0].Image' \
	| tr -d 'sha256:'
}

# dc_name <id>
#
# get the name of a docker container
#
# Arguments
#	id	id or name of a docker container
#
function dc_name {
	readonly port=${1:?"The container's ID must be specified."}

	local inspect_json; # separate declaration from affectation to access the exist status
	inspect_json=$(docker inspect $1)

	if [ $? -ne 0 ]; then return; fi  # exit if failed

	# use 'cat <<<' to handle long lines
	cat <<< $inspect_json \
	| jq --raw-output '.[0].Name'	
}

# sdc [OPTIONS]
#
# launch a fuzzy-finder on docker container ls
#
# Arguments
#	OPTIONS added to the 'docker container ls' command
#
# Shortcuts
#	enter	id
#	ctrl-i	image's id (from dc_image
#	ctrl-n	name (from dc_name)
#
function sdc {
	local title=$'Press [enter] for ID, [ctrl-i] for Image\'s ID, [ctrl-t] for Name:Tag. Use [space] to select multiple entries.\n\n'
	title+=$(docker_containers_TitleLine)
	
	local result; # separate declaration from affectation to access the exist status
	result=$(docker container ls $@ \
	| common_DeleteFirstLine \
	| fzf --multi --reverse \
		--header $title \
		--bind "space:toggle" \
		--bind "enter:execute(echo \"ID\")+accept" \
		--bind "ctrl-i:execute(echo \"IMAGE\")+accept" \
		--bind "ctrl-n:execute(echo \"NAME\")+accept" \
	)

	if [ $? -ne 0 ]; then return; fi # exit if fzf failed (or ctrl-c)

	local mode=$(echo $result | common_OnlyFirstLine) # fzf prints the mode on the first line
	local data=$(echo $result | common_DeleteFirstLine) # fzf prints the line(s) selected after the mode

	
	data=$(cat <<< $data | docker_containers_LineToId) # only keep ids

	# get the operation
	case $mode in
		ID)
		;;
		IMAGE)
			local tmp=$''
			cat <<< $data \
			| while read -r id; do
				tmp+=$(dc_image $id);
				tmp+=$'\n'
			done;

			data=$tmp
		;;
		NAME)
			local tmp=$''
			cat <<< $data \
			| while read -r id; do
				tmp+=$(dc_name $id);
				tmp+=$'\n'
			done;

			data=$tmp
		;;
	esac
	
	# tr replaces new lines by spaces
	# sed replaces the last space by a new line
	echo $data  \
	| tr '\n' ' ' \
	| sed '$s/ $/\n/'
}

# drm [ids]
#
# docker rm on parameter ids if present, else launch 'sdc' to select container(s)
# 
# Arguments
#	ids	id(s) or name(s) of docker container(s)
#
function drm {
	if [ $# -eq 0 ]; then # if no arg
		docker rm $(sdc)
	else
		docker rm $@
	fi
}

# drmf [ids]
#
# docker rm -f on parameter ids if present, else launch 'sdc' to select container(s)
# 
# Arguments
#	ids	id(s) or name(s) of docker container(s)
#
function drmf {
	if [ $# -eq 0 ]; then # if no arg
		docker rm -f $(sdc)
	else
		docker rm -f $@
	fi
}

# ---------------------------------------------------------------------------------------------------
# ABBREVIATIONS & ALIASES - KUBERNETES
# ---------------------------------------------------------------------------------------------------

abbr -S k="kubectl"
abbr -S kg="kubectl get"
abbr -S kga="kubectl get all"
abbr -S kgaa="kubectl get all --all-namespaces"
abbr -S kgp="kubectl get pods"
abbr -S kgpa="kubectl get pods --all-namespaces"
abbr -S kgs="kubectl get services"
abbr -S kgd="kubectl get deploy"
abbr -S kdp="kubectl delete pods"
abbr -S kds="kubectl delete services"
abbr -S kdd="kubectl delete deploy"
abbr -S kl="kubectl logs -f"
abbr -S kt="kubectl top"
abbr -S ktp="kubectl top pods"
abbr -S ktpa="kubectl top pods --all-namespaces"

## --- vpn

abbr -S vpn="sudo ~/tools/hma-linux/hma-vpn.sh -c ~/tools/hma-linux/credentials.txt -p tcp Paris"

# ---------------------------------------------------------------------------------------------------
# LAUNCH STARSHIP
# ---------------------------------------------------------------------------------------------------

eval "$(starship init zsh)"

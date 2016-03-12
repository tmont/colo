#!/bin/bash

############################
startTime=$(date +%s)
red=$(tput setaf 1)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
gray=$(tput setaf 0)$(tput bold)
green=$(tput setaf 2)
bold=$(tput bold)
reset=$(tput sgr0)
yellow=$(tput setaf 3)

run() {
    debug "\`$@\`"
    eval "$@" 2>&1 | logOutput $1
    return $PIPESTATUS
}
debug() {
    log "debug" "$@"
}
debugCmd() {
    name=$1
    shift
    log "${name}" "$@"
}
info() {
    log "info" "$@"
}
logPrompt() {
    log "prompt" "$@"
}

error() {
    log "error" "$@"
}
log() {
    local type=$(basename $1)
    local args=
    shift

    case ${type} in
        info)
            echo -n "[${green}${type}${reset}]"
            ;;
        error)
            echo -n "[${red}${type}${reset}]"
            ;;
        prompt)
            echo -n "[${magenta}${type}${reset}]"
            args="-n"
            ;;
        debug)
            echo -n "[${gray}${type}${reset}]"
            ;;
        *)
            echo -n "[${yellow}${type}${reset}]"
            ;;
    esac

    echo ${args} " $@"
}

checkError() {
    if [ $? -ne 0 ]; then
        error $1
        showElapsed
        exit 1
    fi
}

logOutput() {
    while read cmdOutput; do
        debugCmd $1 "${cmdOutput}"
    done
}
showElapsed() {
    local endTime=$(date +%s)
    local elapsed=$((${endTime} - ${startTime}))
    debug "Finished in ${bold}${elapsed}${reset} seconds"
}

######################

usage() {
    cat <<USAGE
Usage: $0 [options] file

${bold}colo${reset} is an extremely thin, simple, vaguely naive version of Puppet. Basically it
copies files around and restarts services as needed.

Its only argument is a path to a ${bold}manifest file${reset}, which enumerates which files
and services it should do stuff with.



OPTIONS
  ${yellow}--dry-run${reset} Print actions that will be taken, but don't actually do anything
  ${yellow}--silent${reset}  Disable all output
USAGE
}

# parse arguments
while [[ $# > 0 ]]; do
	key="$1"
	shift

	case ${key} in
		-h|--help)
			usage
			exit 0
			;;
		-d|--dir)
			dir="$1"
			shift
			;;
		-e|--encoding)
			encoding="$1"
			shift
			;;
		-m|--metadata)
			key=$1
			metadata+=(["${key,,}"]="$2")
			shift
			shift
			;;
		-p|--prompt)
			prompt=1
			;;
		--midi)
			midi=1
			;;
		--timidity)
			timidity="$1"
			shift
			;;
		-v|--verbose)
			verbose=1
			;;
		-q|--quiet)
			silent=1
			;;
		*)
			files+=("$key")
			;;
	esac
done
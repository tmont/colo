#!/bin/bash

_colo() {
	local cur
	local opts="C -h -s --dry-run --help --no-color --silent"

	COMPREPLY=()

	cur=${COMP_WORDS[COMP_CWORD]}

	case "${cur}" in
		-*)
			COMPREPLY=($(compgen -W '-C -h -s --no-color --help --silent --dry-run' -- "${cur}"))
			;;
	esac

	return 0
}

complete -f -F _colo colo

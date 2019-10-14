# Pedro Fonseca, 2018
#
# Script to navigate code quickly
# Requirements: fzf 
# https://github.com/rssys/code-browser


# Use highlight instead of cat if available
mycat() {
    if hash highlight 2>/dev/null; then
        echo "highlight -O ansi"
    else
        echo "cat"
    fi
}


# Edit a file using vim on a given line number
editline() { 
	EDITOR=${EDITOR-vim}
	if [ "$1" != "" ]
	then
		EDITOR_ARGS=$(echo "$1" | sed -e 's/\([^:]*\):\([^:]*\).*/\1 +\2/')
		${EDITOR} $EDITOR_ARGS
	fi
}

##########################################################################

# Calls fzf to grep the code and then runs vim 
# Receives one optional argument (the initial query)
function g(){
	QUERY=""
	if [ $# -gt 0 ] 
	then
		QUERY="-q ""$@"
	fi
	COLOR="--color=hl:124"
	CAT_COMMAND=$(mycat)
	MATCH=$(cat INDEX.txt | grep '\t' | sed -e "s/\([: ]\)$(printf '\t')/\1        /" | fzf --ansi --print-query $COLOR --reverse -n 2.. -e +s -d ":" $QUERY --preview "${CAT_COMMAND} {1} |head -100 ")
	MATCH_QUERY=$(echo "$MATCH" | head -n 1)
	MATCH_SELECTION=$(echo "$MATCH" | tail -n 1)
	editline "$MATCH_SELECTION"
}

# Repeatedly calls fzf and vim
# Receives one optional arguemnt (the initial query)
function gg(){
	QUERY=""
	if [ $# -gt 0 ] 
	then
		QUERY="-q ""$@"
	fi

	while true;
	do
		COLOR="--color=hl:124"
		CAT_COMMAND=$(mycat)
		MATCH=$(cat INDEX.txt | grep '\t' | sed -e "s/\([: ]\)$(printf '\t')/\1        /" | fzf --ansi --print-query $COLOR --reverse -n 2.. -e +s -d ":" $QUERY --preview "${CAT_COMMAND} {1} |head -100 ")
		QUERY="-q $(echo "$MATCH" | head -n 1)"
		MATCH_SELECTION=$(echo "$MATCH" | tail -n 1)
		if [ $(echo "$MATCH" | wc -l) -ne 2 ]
		then
			return	
		fi
		editline "$MATCH_SELECTION"
	done
}



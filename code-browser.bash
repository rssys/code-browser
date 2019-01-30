# Pedro Fonseca, 2018
#
# Script to navigate code quickly
# Requires fzf installed


# Use highlight instead of cat if available
mycat() {
    if hash highlight 2>/dev/null; then
        echo "highlight -O ansi"
        #echo "highlight -O ansi --syntax=c"
    else
        echo "cat"
    fi
}


# Find the first instance of a file ($1) going up the directory tree
find_file_up(){
	FILENAME="$1"
	x=`pwd`
	while [ "$x" != "/" ] ; do
		FOUND=$(find "$x" -maxdepth 1 -name ${FILENAME})
		if [ "$FOUND" != "" ]
		then
			echo "$FOUND"
			return 
		fi
		x=`dirname "$x"`
	done
	
}

# Edit a file using vim on a given line number
editline() { 
	if [ "$1" != "" ]
	then
		VIM_ARGS=$(echo "$1" | sed -e 's/\([^:]*\):\([^:]*\).*/\1 +\2/')
		vim $VIM_ARGS
	fi
}

##########################################################################

# Calls fzf to grep the code and then runs vim 
# Receives one optional argument (the initial query)
g(){
	QUERY=""
	if [ $# -gt 0 ] 
	then
		QUERY="-q ""$@"
	fi
	COLOR="--color=hl:124"
	CAT_COMMAND=$(mycat)
	MATCH=$(cat GREP_ALL.txt | grep '\t' | sed -e "s/\([: ]\)$(printf '\t')/\1        /" | fzf --ansi --print-query $COLOR --reverse -n 2.. -e +s -d ":" $QUERY --preview "${CAT_COMMAND} {1} |head -100 ")
	MATCH_QUERY=$(echo "$MATCH" | head -n 1)
	MATCH_SELECTION=$(echo "$MATCH" | tail -n 1)
	editline "$MATCH_SELECTION"
}

# Repeatedly calls fzf and vim
# Receives one optional arguemnt (the initial query)
gg(){
	QUERY=""
	if [ $# -gt 0 ] 
	then
		QUERY="-q ""$@"
	fi

	while true;
	do
		COLOR="--color=hl:124"
		CAT_COMMAND=$(mycat)
		MATCH=$(cat GREP_ALL.txt | grep '\t' | sed -e "s/\([: ]\)$(printf '\t')/\1        /" | fzf --ansi --print-query $COLOR --reverse -n 2.. -e +s -d ":" $QUERY --preview "${CAT_COMMAND} {1} |head -100 ")
		QUERY="-q $(echo "$MATCH" | head -n 1)"
		MATCH_SELECTION=$(echo "$MATCH" | tail -n 1)
		if [ $(echo "$MATCH" | wc -l) -ne 2 ]
		then
			return	
		fi
		editline "$MATCH_SELECTION"
	done
}



#!/bin/zsh

JOTDIR=$HOME/.jots
JOTTEMPDIR=$HOME/.jots-temp

jot(){
        TMPFILE="$(mktemp -t jot_zsh)"
        vim $TMPFILE
        trap "rm -f '$TMPFILE'" 0
        echo -n "Jotfile name: "
        read name
        if [[ -a $JOTDIR/$name ]]; then
                echo -n "Jotfile $name already exists. Choose a new name: "
                read name
        fi
        if [[ $name != "" ]]; then
                jotpath=$JOTDIR/$name
                mv $TMPFILE $jotpath
                source $jotpath
        else
                echo "No name given"
                exit 1
        fi
        
}

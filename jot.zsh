#!/bin/zsh

JOTDIR=$HOME/.jots
JOTTEMPDIR=$HOME/.jots-temp

prepare(){
        if [[ ! -d $JOTDIR ]]; then
                mkdir $JOTDIR
                git init $JOTDIR
        fi
        if [[ ! -d $JOTTEMPDIR ]]; then
                mkdir $JOTTEMPDIR
        fi
}

jot_temp(){
        prepare
        TMPFILE="$(mktemp -t tempjot.XXXXXX.zsh)"
        vim $TMPFILE
        trap "rm -f '$TMPFILE'" 0
        echo -n "Jotfile name: "
        read name
        if [[ -a $JOTTEMPDIR/$name ]]; then
                echo -n "Jotfile $name already exists. Choose a new name: "
                read name
        fi
        if [[ $name != "" ]]; then
                jotpath=$JOTTEMPDIR/$name
                mv $TMPFILE $jotpath
        else
                tempname=$(basename "$TMPFILE")
                echo "No name given. Using $tempname"
                jotpath=$JOTTEMPDIR/$tempname
        fi
        
        source $jotpath
}

git_add_file(){
        prev_dir=$(pwd)
        cd $1
        git add $2
        git commit -m "Added new jotfile: $2"
        cd $prev_dir
}

jot(){
        prepare
        TMPFILE="$(mktemp -t tempjot.XXXXXX.zsh)"
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
                git_add_file $JOTDIR $name
        else
                tempname=$(basename "$TMPFILE")
                echo "No name given. Using $tempname"
                jotpath=$JOTDIR/$tempname
                git_add_file $JOTDIR $tempname
        fi
        
        source $jotpath
}

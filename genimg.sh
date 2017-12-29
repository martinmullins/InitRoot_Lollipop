#!/bin/bash

# to allow empty folders in the github, recreate them before pushing
recreateIgnores() {
    cd initrdimg-lollipop/ 
    touch {dev,system,proc,sys,data}/.gitignore
    cd -
}

lollipop() {
    #remove .gitignores
    for i in dev system proc sys data; do
        gitig="initrdimg-lollipop/$i/.gitignore"
        if [[ -e $gitig ]]; then
            echo -n "Git doesn't allow empty directores, removing temporary file: "
            rm -v $gitig
        fi
    done

    if [[ ! -e pad32 ]]; then
        dd if=/dev/zero of=pad32  bs=1M  count=32
    fi
    cd initrdimg-lollipop/ 
    cp ../pad32 ../initroot-lollipop.cpio.gz
    find . | grep -v [.]$ | cpio -v -R root:root -o -H newc | gzip > ../tmp 
    SZ=$(awk '{ print $5; }' <(ls -al ../tmp))
    cat ../tmp >> ../initroot-lollipop.cpio.gz 
    rm -v ../tmp
    cd -
    echo "initrd size is $SZ"
}

$*

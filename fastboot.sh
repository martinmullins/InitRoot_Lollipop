#!/bin/bash
push() {
    fastboot oem config fsg-id "_ "
    fastboot oem config fsg-id "c initrd=0x92000000,$1"
    fastboot flash aleph2 $2
    fastboot continue
}

lollipop() {
    push $1 ./initroot-lollipop.cpio.gz
}

$*

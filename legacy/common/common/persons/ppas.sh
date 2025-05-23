#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /home/astra/common/persons/persons
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o /home/astra/common/persons/persons -T /home/astra/common/persons/link1966.res -e _start
if [ $? != 0 ]; then DoExitLink /home/astra/common/persons/persons; fi
IFS=$OFS

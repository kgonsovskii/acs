#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /home/gonso/common/doors/doors
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o /home/gonso/common/doors/doors -T /home/gonso/common/doors/link5512.res -e _start
if [ $? != 0 ]; then DoExitLink /home/gonso/common/doors/doors; fi
IFS=$OFS

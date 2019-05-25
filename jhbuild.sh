#!/bin/bash


#wget -o gtk-osx-build-setup.sh https://git.gnome.org/browse/gtk-osx/plain/gtk-osx-build-setup.sh
#./gtk-osx-build-setup.sh

export PATH=~/.local/bin:~/gtk/inst/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

do_clean()
{
    (
        local d
        cd ~/gtk/source
        for d in *-[0-9.]
        do
            test  "$d" = "pkgs"  && continue
            test -z "$d" && continue
            test -d "$d" && rm -rf "$d"
        done
    )
    rm -rf ~/gtk/inst
#    pwd
}

do_build()
{
    jhbuild bootstrap && jhbuild build python && 
    jhbuild build meta-gtk-osx-bootstrap meta-gtk-osx-gtk3 && 
    jhbuild build file-roller
}

while test -n "$1"
do
$1 || break
shift
done

#!/bin/sh

if [ -h /dev/root ] && [ -d /run/initramfs/live/updates -o -d /updates ]; then
    info "Applying updates to live image..."
    mount -o bind /run $NEWROOT/run
    # avoid overwriting symlinks (e.g. /lib -> /usr/lib) with directories
    for d in /updates /run/initramfs/live/updates; do
        [ -d "$d" ] || continue
        (
            cd $d
            find . -depth -type d | while read dir; do
                mkdir -p "$NEWROOT/$dir"
            done
            find . -depth \! -type d | while read file; do
                cp -a "$file" "$NEWROOT/$file"
            done
        )
    done
    umount $NEWROOT/run
fi

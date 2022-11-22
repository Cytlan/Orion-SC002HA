#!/bin/bash

# Updater will compare these values with internally-stored values. Make sure they're correct!
BUNDLE="TUYA_AK3918EV330"
VERSION="1.33.10.9"

# Make an empty update file (this file needs to exist in the tar, else the updater will exit early)
# The updater will md5 the file and comapre the result to usr.sqsh4.md5 in the same tar.
# We leave that checksum out just in case, so that the updater will always fail even if we don't kill it.
touch usr.sqsh4

# Make the tar
tar -czvf fake_update.bin usr.sqsh4

# Remove our fake file
rm usr.sqsh4

# Updater will do an md5 checksum of the tar and compare it with the footer info
MD5=($(md5sum fake_update.bin))

# Make footer
FILE_SIZE=$(stat -c %s fake_update.bin)
echo "bundle=$BUNDLE" >> fake_update.bin
echo "version=$VERSION" >> fake_update.bin
echo "author=cytlan" >> fake_update.bin
echo "md5=$MD5" >> fake_update.bin

# Footer needs to be exactly 1024 bytes, and cannot contain non-printable characters
FOOTER_SIZE=$(($(stat -c %s fake_update.bin)-$FILE_SIZE))
FOOTER_PADDING=$((1024-$FOOTER_SIZE))
dd if=/dev/zero bs=1 count=$FOOTER_PADDING | tr "\000" "\040" >> fake_update.bin

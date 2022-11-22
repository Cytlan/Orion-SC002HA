Hacking Orion SC002AH IP camera
===============================

So I decided to buy some cheap IP cameras from Bunnings here in Australia. They only cost A$47, so it's a bargain!

But it sucks that you need some low-quality app to use them, so of course I had to hack them.

The camera is made by Anyka and runs a package labelled TUYA_AK3918EV330. Apparently there are similar cameras on the market that already have been hacked, but unfortunately none of those hacks work on this particular model. Version number is 1.33.10.9.

With the price being only A$47, I could easy afford to buy an extra one to sacrefice. It contains a 8MB SPI flash chip, and dumping that revealed most of the camera's secrets.

How to use
----------
If you just can telnet access **now**, simply place the files in the `sdcard/` directory in this repository on any vFAT formatted SD card, shove it into your camera, reboot it, and access it using `telnet [IP]` with username `root` and password `asdqwe`.

Otherwise, edit the `ak_mp3_player` script to do whatever else you need it to do.

Exploit
-------
This exploit uses the SD card update mechanism to push a fake update, which in turn gives us access to run arbitrary shell scripts on the camera.

The fake update file is a simple `.tar.gz` file with a `.bin` extension, and a 1024 byte footer containing the following key-value pairs:
```txt
bundle=
version=
author=
md5=
```

The `bundle` field must match the package installed on the camera, and the version must be greater than the installed version. The `md5` field is simple an `md5sum` of the `.tar.gz` file before the footer was appended. The `.tar.gz` file must contain at least one update file, but it can simply be an empty file.

(see `make_fake_update.sh` for more details on how the update file needs to look)

If all of these contitions are met, the camera will attempt to execute a program from the SD card called `ak_mp3_player`. We can simply make this a shell script file, and we now have access to run any command we want!

The `ak_mp3_player` script found in this repo just enables telnet, and boots the camera normally.

I haven't done much more hacking than this currently, so I haven't enabled RTMP streaming or anything like that yet, but it should be possible to do now. I'm just happy it was so simple to run arbitrary code on the camera, it requires absolutely no soldering or fancy equipment, and it's not permanent (just delete the files off the SD card to restore the camera to it's factory defaults).

If you use the `ak_mp3_player` as is, you should be able to telnet into your camera using the username `root` and password `asdqwe`.

Happy hacking!

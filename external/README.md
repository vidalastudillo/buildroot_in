# External

To demonstrate the use of the buildroot container of this repository with an [BR2_EXTERNAL tree][DOC_BR2_EXTERNAL], the content of this tree has been constructed based on [this magnificent post that shows how to build Kivy running on a RP2][post_kivy_rpi2].

# Setup

To tell Buildroot to use this external tree, it is required to issue this once:

```
./scripts/run.sh make BR2_EXTERNAL=/root/buildroot/external menuconfig
```

## Configurations available

**myrpi2_defconfig**
The basic image:

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_defconfig
./scripts/run.sh make
```

**myrpi2_splash_defconfig**
(Not working yet, build fails)
- splash screen, means of customizing image assembly - used to effect "silent" boot 

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_splash_defconfig
./scripts/run.sh make
```

**myrpi2_splash_kivy_defconfig**
(Not working yet, build fails)
- THUMB2 instruction set and MUSL LIBC, intention being to reduce image size and speed up cold boot
- /dev creation with eudev
- root login via SSH (pwd "raspberry")
- python3 + kivy

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_splash_kivy_defconfig
./scripts/run.sh make
```

## Saving configs

A modified configuration can be saved using something like this (replacing the text 'mycustom_defconfig'):

```shell
./scripts/run.sh make BR2_DEFCONFIG=/root/buildroot/external/configs/mycustom_defconfig savedefconfig
```

[post_kivy_rpi2]:https://forums.raspberrypi.com/viewtopic.php?t=307052&sid=b8bbc7d25cf2b58cb6d4a35edd716d6a
[DOC_BR2_EXTERNAL]:https://buildroot.org/downloads/manual/manual.html#customize-dir-structure
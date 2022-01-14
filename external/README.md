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
- Starting point.

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_defconfig
./scripts/run.sh make
```

**myrpi2_splash_defconfig**

(Not working yet, splash does not work)

New from previous configuration `myrpi2_defconfig`:
- Splash screen, means of customizing image assembly - used to effect "silent" boot 

Modified from original post:
- Modified `post-image.sh` from the buildroot original.
- Modified `cmdline.txt` from the post original, to include missing splash.
- Changed kernel version:
    BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_5_10=y
    BR2_LINUX_KERNEL_CUSTOM_TARBALL_LOCATION="$(call github,raspberrypi,linux,581049d718caf95f5feb00607ac748d5841cf27c)/linux-581049d718caf95f5feb00607ac748d5841cf27c.tar.gz"
- Added (Build failed as bootcode.bin was not created):
    BR2_PACKAGE_RPI_FIRMWARE_BOOTCODE_BIN=y
    BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI=y

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_splash_defconfig
./scripts/run.sh make
```

**myrpi2_splash_kivy_defconfig**

(splash does not work, yet)

New from previous configuration `myrpi2_splash_defconfig`:
- THUMB2 instruction set and MUSL LIBC, intention being to reduce image size and speed up cold boot
- /dev creation with eudev
- root login via SSH (pwd "raspberry")
- python3 + kivy

Modified from original post:
- Same from configuration `myrpi2_splash_defconfig`

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_splash_kivy_defconfig
./scripts/run.sh make
```

**myrpi2_kivy_rofs_defconfig**

(splash does not work, yet)
(kivy app does not work, yet. No logs. It may be related to i2c-dev not present on etc/modules )

New from previous configuration `myrpi2_splash_kivy_defconfig`:
- read-only file system
- usb storage FAT and NTFS
- h/w pwm
- quadrature encoder input
- I2C, SPI

Modified from original post:
- Same from configuration `myrpi2_splash_kivy_defconfig`

``` shell
./scripts/run.sh make clean all
./scripts/run.sh make myrpi2_kivy_rofs_defconfig
./scripts/run.sh make
```

## Saving configs

A modified configuration can be saved using something like this (replacing the text 'mycustom_defconfig'):

```shell
./scripts/run.sh make BR2_DEFCONFIG=/root/buildroot/external/configs/mycustom_defconfig savedefconfig
```

[post_kivy_rpi2]:https://forums.raspberrypi.com/viewtopic.php?t=307052&sid=b8bbc7d25cf2b58cb6d4a35edd716d6a
[DOC_BR2_EXTERNAL]:https://buildroot.org/downloads/manual/manual.html#customize-dir-structure
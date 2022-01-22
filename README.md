# Buildroot

A Docker image for using [Buildroot][buildroot]. It can be found on [Docker Hub][hub].

## Quick Tips

* Before start, be sure to set Docker Engine configuration on the host allows enough the disk space, processors and other resources.

* To get a clone, use at the host:
``` shell
git clone https://github.com/vidalastudillo/buildroot_in
```

* Check [migrating Buildroot][migrating_buildroot] if you change the Buildroot version on the Dockerfile.

## Get started

1. To get started build the Docker image.

``` shell
docker build -t "advancedclimatesystems/buildroot" .
```

2. Create a [data-only container][data-only] to use as build and download
cache and to store your build products.

``` shell
docker run -i --name buildroot_output advancedclimatesystems/buildroot /bin/echo "Data only."
```

This container has 2 volumes at `/root/buildroot/dl` and `/buildroot_output`.
Buildroot downloads al data to the first volume, the last volume is used as build cache, cross compiler and build results.

## Usage

A small script has been provided to make using the container a little easier.
It's located at [scripts/run.sh][run.sh]. Instructions below show how to build a kernel for the Raspberry Pi using the a defconfig provided by Buildroot.

``` shell
./scripts/run.sh make raspberrypi2_defconfig menuconfig
./scripts/run.sh make
```

Build products are stored inside the container at `/buildroot_output/images`.
Because `run.sh` mounts the local folder `images/` at this place the build products are also stored on the host.

## External tree

To use the custom external tree using the mechanism [described in the documentation][br2_external] related to the `BR2_EXTERNAL` environment variable, the following is required to be called once.

``` shell
./scripts/run.sh make BR2_EXTERNAL=/root/buildroot/external menuconfig
```

From now on, the menuconfig will be aware of the content of the external tree and its identification (By reading the `external.desc` content).

To verify the current settings, an inspection of the internal `br2-external.mk` can be done like this:

``` shell
./scripts/run.sh make
```

And once inside the container:

``` shell
cat /buildroot_output/.br2-external.mk
```

The mechanism related to `BR2_EXTERNAL` is helpful to reference the content of the tree in configuration files. For example, if the `name` defined in `external.desc` is `MYRPI2CFG`, then the `BR2_EXTERNAL_MYRPI2CFG_PATH` can be used to reference absolute paths.

This is useful to tell buildroot where to save the configuration selecting something like this in the `menuconfig` (Assuming the previous defined `MYRPI2CFG` name):

    --> Build options --> Location to save buildroot config: $(BR2_EXTERNAL_MYRPI2CFG_PATH)/configs/my_defconfig
    Exit menuconfig (choose yes to Save) and do:

To remove the external tree, an empty value can be used like this:

``` shell
./scripts/run.sh make BR2_EXTERNAL='' menuconfig
```

## Build with existing config

Once the external tree has been configured as described in the previous section (in order to make buildroot be aware of it), the available configurations can be queried like this:

```shell
./scripts/run.sh make list-defconfigs
```

To demonstrate its use, this repository contains a configuration to build a minimal root filesystem, with Python 3. This config is located at [external/configs/docker_python3_defconfig][docker_python3_defconfig].

Selecting that custom config, cleaning a previous build and making it can be accomplished like this:

```
./scripts/run.sh make docker_python3_defconfig
./scripts/run.sh make clean all
./scripts/run.sh make
```

A modified configuration can be saved using something like this (replacing the text 'mycustom'):

```shell
./scripts/run.sh make BR2_DEFCONFIG=/root/buildroot/external/configs/mycustom_defconfig savedefconfig
```

## Kivy build

There is an example about building different images including a Python Kivy to run on a Raspberry Pi 2 [based on a post][evgueni_post] by [evgueni][evgueni]. It uses the [external tree][external_tree] and it is [documented here][external_tree_doc]

## Docker image from root filesystem

Import the root filesystem in to Docker to create an image run it and start a container.

```shell
docker import - dietfs < images/rootfs.tar
docker run --rm -ti dietfs sh
```

## Creating packages from private git repositories:

The .mk can be defined like this when using Github:

    THETEST_VERSION = main
    THETEST_SITE = git@github.com:<your user name>/<repo name>
    THETEST_SITE_METHOD = git

Refrain to use `main` on the final version, to prevent issues [explained on the documentation][buildroot_generic_package].

To make that work, the container has to be able to connect through SSH to GitHub:

1. Follow the [documentation from GitHub about it][github_ssh].
2. Place a folder named .ssh on the host computer with the generated identification and .PUB files to make those available to the container.

To test this, get into the container:
```shell
./scripts/run.sh make
```

Once there, you have to get successful responses to commands like this:

```shell
ssh git@github.com
git clone git@github.com:<your user name>/<repo name>
```

This has been produced thanks to the invaluable support of `y_morin` and `troglobit` from the #buildroot IRC Channel.

## License

This software is licensed under Mozilla Public License.
It is based on the original work by: 
&copy; 2017 Auke Willem Oosterhoff and [Advanced Climate Systems][acs].
It has been modified and extended by Mauricio Vidal from [VIDAL & ASTUDILLO Ltda][va].

[va]:https://www.vidalastudillo.com
[acs]:http://advancedclimate.nl
[buildroot]:http://buildroot.uclibc.org/
[data-only]:https://docs.docker.com/userguide/dockervolumes/
[hub]:https://hub.docker.com/r/advancedclimatesystems/docker-buildroot/builds/
[run.sh]:scripts/run.sh
[docker_python3_defconfig]:external/configs/docker_python3_defconfig
[external_tree]:external
[external_tree_doc]:external/README.md
[br2_external]:http://buildroot.uclibc.org/downloads/manual/manual.html#outside-br-custom
[docker_blog]:https://blog.docker.com/2013/06/create-light-weight-docker-containers-buildroot/
[migrating_buildroot]:http://buildroot.uclibc.org/downloads/manual/manual.html#migrating-from-ol-versions
[evgueni]:https://forums.raspberrypi.com/memberlist.php?mode=viewprofile&u=208985&sid=be8a772e5aef87a4991576d69e510cce
[evgueni_post]:https://forums.raspberrypi.com/viewtopic.php?t=307052&sid=b8bbc7d25cf2b58cb6d4a35edd716d6a
[github_ssh]:https://docs.github.com/en/authentication/connecting-to-github-with-ssh
[buildroot_generic_package]:https://buildroot.org/downloads/manual/manual.html#generic-package-reference

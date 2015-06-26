# Sabayon Builder: a Docker Project #

Attention! It's under strong development

State: Alpha

The purpose of this project is to provide an image of Sabayon docker-capable builder.
It is just a [Sabayon base](https://github.com/mudler/docker-sabayon-base) with upgrades and compilation tools.

Images are also on Docker Hub [sabayon/builder-amd64](https://registry.hub.docker.com/u/sabayon/builder-amd64/)

## First steps on docker

Ensure to have the daemon started and running:

    sudo systemctl start docker

## Building sabayon-spinbase locally

    git clone https://github.com/mudler/docker-sabayon-builder-amd64.git docker-sabayon-builder
    cd docker-sabayon-builder
    sudo docker build -t sabayon/builder-amd64 .

## Pulling sabayon-spinbase from Docker Hub

    sudo docker pull sabayon/builder-amd64

## Converting the image from Docker to use it with [Molecules](https://github.com/Sabayon/molecules)

### Only with undocker, without squashing the layers

After pulling the docker image, install [undocker](https://github.com/larsks/undocker/) and then as root:

    docker save sabayon/builder-amd64:latest | undocker -i -o spinbase sabayon/builder-amd64:latest

### Using [docker-squash](https://github.com/jwilder/docker-squash)
You can also squash the image with [docker-squash](https://github.com/jwilder/docker-squash) and then extract your layers.

    sudo docker save sabayon/builder-amd64:latest | sudo TMPDIR=/dev/shm docker-squash -t sabayon/builder-amd64:squashed > /your/prefered/path/Spinbase.tar

You can replace /dev/shm with your prefered tmpdir

### With undocker, but squashing the layers

The squash can also been accomplished creating a container from the image, exporting it and then importing it back.

    sudo docker run -t -i sabayon/builder-amd64:latest /bin/bash
    $ exit # You should drop in a shell, exit, you should see a container id, otherwise find it :
    sudo docker ps -l
    sudo docker export <CONTAINER ID> | docker import - sabayon/builder-amd64:squashed
    docker save sabayon/builder-amd64:squashed | undocker -i -o spinbase sabayon/builder-amd64:squashed

Docker will loose the history revision and then you can estract the layer, using as base for chroot.

You now have the tree on the *spinbase/* directory

If you are planning to use the resulting files as a chroot, don't forget to set a nameserver on resolv.conf file

    echo "nameserver 208.67.222.222" > spinbase/etc/resolv.conf


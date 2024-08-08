# Gaming on Archlinux Arm64 PC using LXC

## Prerequisite

```bash
sudo pacman -S lxd
```

Add your user to the group `lxd`:

```bash
sudo usermod -aG lxd $USER
```

The default `lxd` service is not compatible with NetworkManager. Manually change the file `/usr/lib/systemd/system/lxd.service`:

```
[Unit]
Description=LXD Container Hypervisor
After=lxcfs.service
Requires=lxcfs.service lxd.socket
Documentation=man:lxd(1)

...
```

Remove the `network-online` dependency.

Run `lxd init` and type Enter until it ends.

## Setting up the ID mapping

Change `/etc/subuid` and `/etc/subgid`:

```
root:$UID:1
lxd:1000000:1000000000
root:1000000:1000000000
<USER>:1001000000:1000000
```

Change `<USER>` to your user name. Change $UID.

## Create the container

Add a remote:

```
lxc remote add images https://images.lxd.canonical.com --accept-certificate --public
```

Use `lxc image list images: debian bookworm arm64` to view all possible images.

```
+--------------------------+--------------+--------+---------------------------------------+--------------+-----------+-----------+------------------------------+
|          ALIAS           | FINGERPRINT  | PUBLIC |              DESCRIPTION              | ARCHITECTURE |   TYPE    |   SIZE    |         UPLOAD DATE          |
+--------------------------+--------------+--------+---------------------------------------+--------------+-----------+-----------+------------------------------+
| debian/12 (7 more)       | fc3ce07b18a4 | yes    | Debian bookworm arm64 (20240805_0006) | aarch64      | CONTAINER | 92.95MiB  | Aug 5, 2024 at 12:00am (UTC) |
+--------------------------+--------------+--------+---------------------------------------+--------------+-----------+-----------+------------------------------+
| debian/12/cloud (3 more) | 2ab833a0d301 | yes    | Debian bookworm arm64 (20240805_0005) | aarch64      | CONTAINER | 118.45MiB | Aug 5, 2024 at 12:00am (UTC) |
+--------------------------+--------------+--------+---------------------------------------+--------------+-----------+-----------+------------------------------+
```

We use `debian/12` image.

```
export cname=game   # Assume the container name is game
lxc launch images:debian/12 $cname
```

## Configure the container

```
lxc config set $cname raw.idmap "both $UID 1000"
lxc config device add $cname gpu gpu
lxc config device set $cname gpu uid 1000
lxc config device set $cname gpu gid 1000

lxc config device add $cname X0 disk source=/tmp/.X11-unix path=/tmp/.X11-unix

lxc config device add $cname user disk source=/run/user/$UID path=/mnt/1000
```

You can also mount another directory to use in the container:

```
lxc config device add $cname disk1 disk source=/<path on your host> path=/mnt/disk1 # Path in the container
```

Now restart the container:

```
lxc restart $cname
```

Enter the shell and install wine:

```
lxc exec $cname -- bash
apt update
apt install curl -y
bash <(curl -s https://raw.githubusercontent.com/linsyking/game-lxc-arm64/main/install.sh)
```

The script may run about 40 - 60 minutes.

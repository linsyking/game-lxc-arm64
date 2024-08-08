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
lxc launch images:debian/12 game
```

## Configure the container

```
lxc config set game raw.idmap "both $UID 1000"
lxc config device add game gpu gpu
lxc config device set game gpu uid 1000
lxc config device set game gpu gid 1000

lxc config device add game X0 disk
lxc config device set game X0 path /tmp/.X11-unix
lxc config device set game X0 source /tmp/.X11-unix
lxc config device add game user disk
lxc config device set game user path /mnt/1000
lxc config device set game user path /run/user/$UID # Change UID
```

You can also mount another directory to use in the container:

```
lxc config device add game disk1 disk
lxc config device set game disk1 path /mnt/disk1 # Path in the container
lxc config device set game disk1 path /path on your host
```

Now restart the container:

```
lxc restart game
```

Enter the shell:

```
lxc exec game -- bash
```

Run `apt update` and `apt upgrade` to update the system.

Install the following packages:

```
apt install weston mesa-utils vulkan-tools
```

Now change `.bashrc`:

```
export XDG_RUNTIME_DIR=/mnt/1000
export WAYLAND_DISPLAY=wayland-0
export QT_QPA_PLATFORM=wayland
export DISPLAY=:1
export PULSE_SERVER=unix:/mnt/1000/pulse/native
export PULSE_LATENCY_MSEC=50
export XAUTHORITY=$(ls /mnt/1000/xauth*)
```

Run `source .bashrc` to reload.

You should be able to run graphical apps now.

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

Make sure your user id is 1000. (It's possible to use other user ID but it's too complex)

## Setting up the ID mapping

Change `/etc/subuid` and `/etc/subgid`:

```
root:1000:1
lxd:1000000:1000000000
root:1000000:1000000000
<USER>:1001000000:1000000
```

Change `<USER>` to your user name.

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

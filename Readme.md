# Gaming on Archlinux Arm64 PC using LXC

## Prerequisite

```bash
sudo pacman -S lxd
```

Add your user to the group `lxd`:

```bash
sudo usermod -aG lxd $USER
```

The default `lxd` service is not compatible with NetworkManager. Manually change the file

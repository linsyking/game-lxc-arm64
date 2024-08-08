# Gaming on Archlinux Arm64 PC using LXC

## Prerequisite

```bash
sudo pacman -S lxd
```

Add your user to the group `lxd`:

```bash
sudo usermod -aG lxd $USER
```

**Hint**. You might encounter slow startup of lxd. This is due to `systemd-networkd` problem. You need to add the network interface.

#!/bin/bash

set -e

# Run as root

echo """
export XDG_RUNTIME_DIR=/mnt/1000
export WAYLAND_DISPLAY=wayland-0
export QT_QPA_PLATFORM=wayland
export DISPLAY=:1
export PULSE_SERVER=unix:/mnt/1000/pulse/native
export PULSE_LATENCY_MSEC=50
export XAUTHORITY=\$(ls /mnt/1000/xauth*)""" >> ~/.bashrc

dpkg --add-architecture armhf
apt-get update
apt-get upgrade -y
apt-get install weston mesa-utils vulkan-tools ninja-build gcc-arm-linux-gnueabihf wget git cmake -y
apt-get install libc6:armhf -y


git clone https://github.com/ptitSeb/box86
git clone https://github.com/ptitSeb/box64

cd box64
cmake -S . -B build -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
cmake --build build
cd build
ninja install

cd ..
cd ..
cd box86

CC=arm-linux-gnueabihf-gcc cmake -S . -B build -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -G Ninja
cmake --build build
cd build
ninja install
cd ..
cd ..

rm -rf box86 box64


# Install wine dependencies

apt-get install -y libasound2:armhf libc6:armhf libglib2.0-0:armhf libgphoto2-6:armhf libgphoto2-port12:armhf \
        libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf libldap-2.5-0:armhf libopenal1:armhf libpcap0.8:armhf \
        libpulse0:armhf libsane1:armhf libudev1:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libxext6:armhf \
        libasound2-plugins:armhf ocl-icd-libopencl1:armhf libncurses6:armhf libncurses5:armhf libcap2-bin:armhf libcups2:armhf \
        libdbus-1-3:armhf libfontconfig1:armhf libfreetype6:armhf libglu1-mesa:armhf libglu1:armhf libgnutls30:armhf \
        libgssapi-krb5-2:armhf libkrb5-3:armhf libodbc1:armhf libosmesa6:armhf libsdl2-2.0-0:armhf libv4l-0:armhf \
        libxcomposite1:armhf libxcursor1:armhf libxfixes3:armhf libxi6:armhf libxinerama1:armhf libxrandr2:armhf \
        libxrender1:armhf libxxf86vm1:armhf libc6:armhf libcap2-bin:armhf

apt-get install -y libasound2:arm64 libc6:arm64 libglib2.0-0:arm64 libgphoto2-6:arm64 libgphoto2-port12:arm64 \
		libgstreamer-plugins-base1.0-0:arm64 libgstreamer1.0-0:arm64 libldap-2.5-0:arm64 libopenal1:arm64 libpcap0.8:arm64 \
		libpulse0:arm64 libsane1:arm64 libudev1:arm64 libunwind8:arm64 libusb-1.0-0:arm64 libvkd3d1:arm64 libx11-6:arm64 libxext6:arm64 \
		ocl-icd-libopencl1:arm64 libasound2-plugins:arm64 libncurses6:arm64 libncurses5:arm64 libcups2:arm64 \
		libdbus-1-3:arm64 libfontconfig1:arm64 libfreetype6:arm64 libglu1-mesa:arm64 libgnutls30:arm64 \
		libgssapi-krb5-2:arm64 libjpeg62-turbo:arm64 libkrb5-3:arm64 libodbc1:arm64 libosmesa6:arm64 libsdl2-2.0-0:arm64 libv4l-0:arm64 \
		libxcomposite1:arm64 libxcursor1:arm64 libxfixes3:arm64 libxi6:arm64 libxinerama1:arm64 libxrandr2:arm64 \
		libxrender1:arm64 libxxf86vm1:arm64 libc6:arm64 libcap2-bin:arm64

wget https://github.com/Kron4ek/Wine-Builds/releases/download/9.14/wine-9.14-staging-tkg-amd64.tar.xz

# Now you can run wine!

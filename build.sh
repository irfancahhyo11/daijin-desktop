# Copyright 2024 moe-hacker
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install dependencies.
printf "\033[1;38;2;254;228;208m"
printf "Install dependencies.\n"
printf "\033[0m"
sleep 1
apt install coreutils p7zip-full gettext tar unzip zip git wget dpkg curl nano proot axel util-linux pv gawk clang binutils golang make libcap-dev libseccomp-dev
# Update submodule.
printf "\033[1;38;2;254;228;208m"
printf "Init submodules.\n"
printf "\033[0m"
sleep 1
git submodule update --init
# Start build.
printf "\033[1;38;2;254;228;208m"
printf "Build.\n"
printf "\033[0m"
sleep 1
# Create build dir.
mkdir build
mkdir build/DEBIAN
mkdir -p build/usr/bin
mkdir -p build/usr/share
mkdir -p build/usr/share/daijin/proc/
mkdir -p build/usr/etc
# Copy dpkg config file.
cp -r dpkg-conf/* build/DEBIAN/
chmod -R 755 build/DEBIAN
# Compile rurima.
cd src/rurima
git submodule update --init
./configure -s
make
cp rurima ../../build/usr/bin/
echo "echo -e \"\033[33mruri is built-in in rurima now, please use \033[32mrurima r\033[33m instead\033[0m\"" >../../build/usr/bin/ruri
chmod 777 ../../build/usr/bin/ruri
# Copy rootfstool.
cd ../rootfstool
cp rootfstool ../../build/usr/bin/
# Return to root dir.
cd ../..
# Copy rurima config file.
cp src/rurima.conf build/usr/etc/rurima.conf
# Decompress dummy files of procfs.
tar -xf src/share/proc.tar.xz -C build/usr/share/daijin/proc/
# Copy shared sh script.
cp src/share/*.sh build/usr/share/daijin/
# Copy daijin main script.
cp src/daijin build/usr/bin/
# Fix permission.
chmod 755 build/usr/bin/*
chmod 755 build/usr/share/daijin/*.sh
cd build
# Set build info.
size=$(du -s . | awk '{printf $1}')
sed -i "s/\[size\]/${size}/" DEBIAN/control
arch=$(dpkg --print-architecture)
sed -i "s/\[arch\]/${arch}/" DEBIAN/control
# Build deb.
dpkg -b . ../daijin-${arch}.deb
# Clean.
cd ..
rm -rf build
# Done.
printf "\033[1;38;2;254;228;208m"
printf "Build done, package: daijin-${arch}.deb\n"
printf "\033[0m"

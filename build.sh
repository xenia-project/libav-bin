#!/usr/bin/env bash
set -e

THIS_SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )

export PATH=/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 14.0/VC/bin/amd64/:$PATH
/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 14.0/VC/bin/amd64/vcvars64.bat

echo ""
echo "Removing old output..."
rm -rf include/
rm -rf lib/
rm -rf libav-source/
rm -rf temp/

echo ""
echo "Cloning libav from master..."
mkdir -p libav-source
cd libav-source
git init
git config core.autocrlf false
git remote add origin git://git.libav.org/libav.git
git pull origin master

echo ""
echo "Patching with xma fix..."
patch -p1 < $THIS_SCRIPT_DIR/xma-patch.diff

echo ""
echo "Running ./configure (debug)..."
./configure \
    --toolchain=msvc \
    --arch=x86_64 \
    --extra-cflags="-MDd" \
    --extra-ldflags="user32.lib" \
    --disable-everything \
    --disable-programs \
    --disable-all \
    --enable-avcodec \
    --enable-avutil \
    --enable-decoder=wmapro \
    --prefix=$THIS_SCRIPT_DIR/temp/

echo ""
echo "Running make install (debug)..."
make install-headers install-libs

mkdir -p $THIS_SCRIPT_DIR/lib/Debug/
mv $THIS_SCRIPT_DIR/temp/lib/* $THIS_SCRIPT_DIR/lib/Debug/

echo ""
echo "Running ./configure (release)..."
./configure \
    --toolchain=msvc \
    --arch=x86_64 \
    --extra-cflags="-MD" \
    --extra-ldflags="user32.lib" \
    --disable-everything \
    --disable-programs \
    --disable-all \
    --enable-avcodec \
    --enable-avutil \
    --enable-decoder=wmapro \
    --prefix=$THIS_SCRIPT_DIR/temp/

echo ""
echo "Running make install (release)..."
make install-headers install-libs

mkdir -p $THIS_SCRIPT_DIR/lib/Release/
mv $THIS_SCRIPT_DIR/temp/lib/* $THIS_SCRIPT_DIR/lib/Release/

mkdir -p $THIS_SCRIPT_DIR/
mv $THIS_SCRIPT_DIR/temp/include/ $THIS_SCRIPT_DIR/include/

rm -rf $THIS_SCRIPT_DIR/temp

cd ..

echo ""
echo "Cleaning up build temp"
#rm -rf libav-source

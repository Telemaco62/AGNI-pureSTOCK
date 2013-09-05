#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_STOCK.sh
. ~/gcc_4.6.sh

export ARCH=arm

if [ ! -f $KERNELDIR/.config ];
then
  make defconfig psn_i9500_v1.0_defconfig
fi

. $KERNELDIR/.config

mv .git .git-halt

cd $KERNELDIR/
make -j2 || exit 1

mkdir -p $KERNELDIR/BUILT/lib/modules

rm $KERNELDIR/BUILT/lib/modules/*
rm $KERNELDIR/BUILT/zImage

find -name '*.ko' -exec cp -av {} $KERNELDIR/BUILT/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT/lib/modules/*
cp $KERNELDIR/arch/arm/boot/zImage $KERNELDIR/BUILT/

mv .git-halt .git

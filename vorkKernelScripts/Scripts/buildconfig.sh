#!/bin/bash

zImageDIR=$VORKSCRIPT_DIR/Awesome.zip/tmp/ironkrnL/zImage
. $VORKSCRIPT_DIR/Scripts/kernelcompile.sh

mv $SOURCE_DIR/arch/arm/boot/zImage $zImageDIR

cd $VORKSCRIPT_DIR/

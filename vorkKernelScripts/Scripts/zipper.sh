#!/bin/bash

cd $VORKSCRIPT_DIR

if [ "$1" == "Awesome" ]; then
	echo "#!/sbin/sh" > $1.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$device mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $1.zip/tmp/ironkrnL/installkernel.sh
	if [ "$device" == "LGP990" ]; then
		cp -r mdfiles/ril $1.zip/tmp/ironkrnL/files
	fi
fi


cd $VORKSCRIPT_DIR/$1.zip


echo Making update.zip ...
zip -r -y -q update *
echo
echo update.zip created

mv update.zip ../$signed_file


cd $VORKSCRIPT_DIR/

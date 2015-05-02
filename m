#!/usr/bin/env bash
# simple mount function
#
# by Jack (jack@ai4me.de)
#
# requires udevil
#
# to allow mounting of mapper devices change these lines in /etc/udevil/udevil.conf
#   allowed_devices = /dev/*, /dev/mapper/*
#   allowed_internal_devices = /dev/mapper/*
#

unset GREP_OPTIONS

function usage(){
echo "$0 [-h, --help]"
echo
echo "	-h, --help,	print usage"
echo
echo "	stdin,	[1..n] mount/unmount"
echo "			r	reload list"
echo "			a	abort"
echo
echo "This prints a list of numbered mountable volumes and mounts a chosen device via pmount."
echo "To mount oder unmount a volume enter its number. Any other input will lead to no operation."
}


function main(){
# list all devices
args="/dev/**"
filter='-oe /dev/sd.* -oe /dev/mmcblk.* -oe /dev/cdrom*'

if [ -e /dev/mapper ]; then
	args="$args /dev/mapper/*"
	filter="$filter -oe /dev/mapper/[^c].*"
fi

devList=$(ls -dt --color=never ${args} | grep ${filter})


# walk through devices, check if mounted, echo
declare -a dev
j=0

for i in $devList; do
	j=$((j+1))
	if [ "`mount|grep -o \"$i \"`" != "" ];then
		echo -en "\e[1;32m"
		m=`mount | grep "$i" | cut -d " " -f 3`
	else
		m=$(cat /sys/block/$(basename $i)/device/vendor > /dev/null 2>&1)
	fi
	echo -e "\t$j  $i\t\t$m\e[0m"
	m=""
	dev[$j]=$i
done

# get user choice
echo "(1)"
read b


# no input use 1
if [ "$b" = "" ];then
	b=1
fi

# command from user
if [ "$b" = "r" ]; then
	main
	b="a"
fi

# invalid device number
if ! [[ $(seq 1 $j) =~ $b ]];then
	echo "No operation" >&2
	return
fi

# use udevil to mount or unmount
x=`mount|grep ${dev[$b]}`
if [ "$x" = "" ];then
	echo "udevil mount ${dev[$b]}";
	ret=$(udevil mount ${dev[$b]})
else
	echo "udevil umount ${dev[$b]}";
	ret=$(udevil umount ${dev[$b]})
fi
echo $ret
}

if [ ! "$1" = "" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	usage
	return
fi

main

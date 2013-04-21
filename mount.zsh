#
# simple mount function for zsh
# 
# by Jack (jack@ai4me.de)
#
# place this file in ~/.oh-my-zsh/custom/mount.zsh
#
# requires udevil
#

function mmountusage32882(){
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

function mmountmain8293872(){
# list all devices
a=`ls -dt --color=never /dev/**|grep -oe "/dev/sd.*" -oe "/dev/mmcblk.*" -oe "/dev/cdrom*"`
j=0
dev=()
# walk thru devices, check if mounted, echo
echo $a | while read i;do
	j=$((j+1))	
	if [ "`mount|grep -o \"$i \"`" != "" ];then
		echo -en "\e[1;32m"
		m=`mount | grep "$i" | cut -d " " -f 3`
	fi
	echo -e "\t$j  $i\t\t$m\e[0m"
	m=""
	dev[$j]=$i
done
echo "(1)"
read b
# no input use 1
if [ "$b" = "" ];then
	b=1
fi
# is user input valid
if [ "$b" = "r" ]; then
	mmountmain8293872
	b="a"
fi
if ! [[ $(echo {1..$j}) =~ $b ]];then
	return
fi
x=`mount|grep $dev[$b]`
# use pmount to mount or unmount
if [ "$x" = "" ];then
	echo "udevil mount $dev[$b]";udevil mount $dev[$b]
else
	echo "udevil umount $dev[$b]";udevil umount $dev[$b]
fi	
}

function m(){
	if [ ! "$1" = "" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		mmountusage32882
		return
	fi
	
	mmountmain8293872
}

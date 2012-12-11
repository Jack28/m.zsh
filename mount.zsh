#
# simple mount function for zsh
# 
# by Jack (jack@ai4me.de)
#
# place this file in ~/.oh-my-zsh/custom/mount.zsh
#
# requires pmount
#

function m(){
# list all devices
a=`ls -dt --color=never /dev/**|grep -oe "/dev/sd.*" -oe "/dev/mmcblk.*"`
j=0
dev=()
# walk thru devices, check if mounted, echo
echo $a | while read i;do
	j=$((j+1))	
	if [ "`mount|grep -o \"$i \"`" != "" ];then
		echo -en "\e[1;32m"
	fi
	echo -e "\t$j  $i\e[0m"
	dev[$j]=$i
done
echo "(1)"
read b
# no input use 1
if [ "$b" = "" ];then
	b=1
fi
# is user input valid
if ! [[ $(echo {1..$j}) =~ $b ]];then
	return 
fi
x=`mount|grep $dev[$b]`
# use pmount to mount or unmount
if [ "$x" = "" ];then
	echo "pmount $dev[$b]";pmount $dev[$b]
else
	echo "pumount $dev[$b]";pumount $dev[$b]
fi	
}


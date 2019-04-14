#!/bin/bash
#set -x
function compressquality {
	originfile=$1
	path=${originfile%/*}
	temp=${originfile##*.}
	temp=${temp^^}
	new_name=$path"/new.jpeg"
	if [[ $temp == "JPEG" ]];then
		$(convert $1 -quality $2 $new_name)
		echo "compress quality finish"
	else
		echo "We can only compress JPEG images"
	fi
}
function compressresolution {
	originfile=$1
	path=${originfile%/*}
	temp=${originfile##*.}
	new_name=$path"/aftercompress."$temp
	temp=${temp^^}
	if [[ $temp == "JPEG" || $temp == "PNG" || $temp == "SVG" ]];then
		if [[ $2 == "h" ]];then
			$(convert -resize "x"$3 $1 $new_name)
		elif [[ $2 == "w" ]];then
			$(convert -resize $3 $1 $new_name)
		echo "compress solution finish"
	        fi
	fi
}

function addwatermark {
	originfile=$1
	path=${originfile%/*}
	temp=${originfile##*.}
	new_name="afteraddwater."${temp}
	$(convert $1 -gravity $2 -fill $3 -pointsize $4 -draw 'text 5,5 '\'$5\' $path"/"$new_name)
	echo "add watermark finish"
}
function rename {
	originfile=$1
	path=${originfile%/*}
	mytring=$2
	suffix=${originfile##*.}
	temp=${originfile##*/}
	preffix=${temp%.*}
	if [[ $3 == "before" ]];then
		result_name=$path"/"${mytring}${preffix}"."${suffix};
		$(mv "$originfile" "$result_name")
	elif [[ $3 == "after" ]];then
		result_name=$path"/"${preffix}${mytring}"."${suffix};
		$(mv "$originfile" "$result_name")
	fi
	echo "rename finish"
}
function changeformat {
	originfile=$1
	suffix=${originfile##*.}
	preffix=${originfile%.*}
	suffix=${suffix^^}
	if [[ $suffix == "PNG" || $suffix == "SVG" ]];then
		new_name=${preffix}".jpg"
		$(convert $originfile $new_name)
		echo "change format finish"
	fi
}
function helpinfo {
	echo "this is help information"
	echo "usage:bash ImageProcessing.sh -f filename [OPTIONS][PARAMETER]"
	echo "-f      filename"
	echo "-cq     image compression and compress quality"
	echo "-cr     compress image resolution"
	echo "-crt    compress image rosolution by width or heigh"
	echo "        w|h"
	echo "-aw     add text watermark"
	echo "-awg    gravity"
	echo "-awf    color"
	echo "-aws    size"
	echo "-rn     add string to filename"
	echo "-rnt    before|after"
	echo "-cv     change image format to jpg"
}
while [ "$1" != "" ];do
	case $1 in
		-f)      shift
			 filename=$1
			 ;;
		-cq)     shift
		         quality=$1
		         ;;
		-cr)     shift
		         ratio=$1
			 ;;
	        -crt)    shift
			 crtype=$1
		         ;;
		-aw)     shift
		         textcontent=$1
		         ;;
		-awg)    shift
		         gravity=$1
			 ;;
		-awf)    shift
		         fill=$1
			 ;;
		-aws)    shift
		         pointsize=$1
			 ;;
		-rn)     shift
		         mystring=$1
			 ;;
	        -rnt)    shift
		         rntype=$1
		         ;;
	        -cv)     shift
		         changeformat=1
			 ;;
		-h|--help)
			helpinfo
			;;
	 esac
         shift
done
if [[ $quality && $filename ]];then
	compressquality $filename $quality
fi
if [[ $ratio && $filename ]];then
	compressresolution $filename $crtype $ratio
fi
if [[ $textcontent && $filename ]];then
	addwatermark $filename $gravity $fill $pointsize  $textcontent
fi
if [[ $mystring && $filename ]];then
	rename $filename $mystring $rntype
fi
if [[ $changeformat ]];then
	changeformat $filename
fi





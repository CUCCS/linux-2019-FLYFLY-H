#!/bin/bash
function file_process {
	file_path=$1
	count=0
	i=0
	while read -r line; do
		if [[ $count == 0 ]];then
			count=1
		else	
			arr=(${line// /*})
			#gr[$i]=${arr}
			#co[$i]=${arr[1]}
			#ra[$i]=${arr[2]}
			#je[$i]=${arr[3]}
			po[$i]=${arr[4]}
			ag[$i]=${arr[5]}
			#se[$i]=${arr[6]}
			#cl[$i]=${arr[7]}
			pl[$i]=${arr[8]}
			
		fi
		i=$(($i+1))
	done < $file_path
}
function age {
	blow=0
	between=0
	up=0
	total=0
	for n in ${ag[@]};do
		if [[ $n -lt 20 ]];then
			blow=$(($blow+1))
		elif [[ $n -ge 20 && $n -le 30 ]];then
			between=$(($between+1))
		elif [[ $n -gt 30 ]];then
			up=$(($up+1))
		fi
		total=$(($total+1))
	done
	result1=`awk 'BEGIN{printf "%.2f%%\n",('$blow'/'$total')*100}'`
        result2=`awk 'BEGIN{printf "%.2f%%\n",('$between'/'$total')*100}'`
	result3=`awk 'BEGIN{printf "%.2f%%\n",('$up'/'$total')*100}'`		
	echo "年龄低于20球员数量是"$blow",""占百分比为"$result1
	echo "年龄在20到30之间的球员数量是"$between",""占百分比为"$result2
	echo "年龄在30以上的球员数量是"$up",""占百分比为"$result3
}

function position {
	declare -A dic
	total=0
	for n in ${po[@]};do
		if [[ !${dic[$n]} ]];then
			dic[$n]=$((${dic[$n]}+1))
		else
			dic[$n]=0
		fi
		total=$((total+1))
	done
	for key in ${!dic[@]};do
		result=`awk 'BEGIN{printf "%.2f%%\n",('${dic[$key]}'/'$total')*100}'`
		echo $key"位置的球员数是"${dic[$key]}",""所占比例为"$result
	done

}

function name {
	max=''
	min=''
	max_lenth=0
	min_lenth=0
	count=0
	for n in ${pl[@]};do
		if [[ $count == 0 ]];then
			max_lenth=${#n}
			max=$n
			min_lenth=${#n}
			min=$n
			count=1
		else
			if [[ ${#n} -gt max_lenth ]];then
				max=$n
				max_lenth=${#n}
			elif [[ ${#n} -lt min_lenth ]];then
				min=$n
			       	min_lenth=${#n}
			fi
		fi
        done	      
	echo "名字最长的球员是"${max//\*/ }
	echo "名字最短的球员是"${min//\*/ }
}

function agename {
	oldest=0
	youngest=0
	oname=''
	yname=''
	for n in ${ag[@]};do	
		if [[ $total == 0 ]];then
			oldest=$n
			youngest=$n
			oname=${pl[$total+1]}
			yname=${pl[$total+1]}
		else
			if [[ $n -gt $oldest ]];then
				oldest=$n
				oname=${pl[$total+1]}
			elif [[ $n -lt $youngest ]];then
				youngest=$n
				yname=${pl[$total+1]}
			fi
		fi
	done
	echo "年龄最大的球员是"${oname//\*/ }" "$oldest"岁"
	echo "年龄最小的球员是"${yname//\*/ }" "$youngest"岁"
}

function helpinfo {
	echo "This is help information"
	echo "Usage: bash WorldCupPlayer.sh -f wolrdcupplayerinfo.tsv [OPTIONS] [PARAMENTER]"
	echo "-f        处理文件数据"
	echo "-a        统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
	echo "-p        统计不同场上位置的球员数量、百分比"
	echo "-n        找出名字最长的球员以及名字最短的球员"
	echo "-m        找出年龄最大的球员以及年龄最小的球员"
	echo "-h|-help        获取帮助信息"
}

while [ "$1" != "" ] ; do
	case $1 in
		-f)
			shift
			file_process $1
			;;
		-a)
			echo " 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
			age
			;;
		-p)
			echo "统计不同场上位置的球员数量、百分比"
			position
			;;
		-n)
			echo "求出名字最长的球员以及名字最短的球员"
			name
			;;
		-m)
			echo "求出年龄最大的球员以及年龄最小的球员"
			agename
			;;
		-h|--help)
			helpinfo
			;;
	esac
	shift
done
	


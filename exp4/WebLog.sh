#!/bin/bash
function Q1 {
	awk '{sum[$1]+=1} END {for(i in sum) {print sum[i],i}}' web_log.tsv | sort -n -r -k 1 | head -n 100 
}
function Q2 {
        awk '{sum[$1]+=1} END {for(i in sum) {print sum[i],i}}' web_log.tsv | grep -E "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]" |  sort -n -r -k 1 | head -n 100 
}
function Q3 {	
	awk '{sum[$5]+=1} END {for(i in sum) {print sum[i],i}}' web_log.tsv | sort -n -r -k 1 | head -n 100 
}
function Q4 {
	awk '{sum[$6]+=1;total+=1} END {for(i in sum) {printf("状态码:%-10d数量:%-15d百分比为:%.2f%%\n",i,sum[i],sum[i]/total*100)}}' web_log.tsv | sort -n -r -k 2
}
function Q5 {
	awk -F '\t' '{if($6~/^403/) sum[$6" "$5]+=1} END {for(i in sum){print sum[i],i}}' web_log.tsv | sort -n -r -k 1 | head -n 10  
	awk -F '\t' '{if($6~/^404/) sum[$6" "$5]+=1} END {for(i in sum){print sum[i],i}}' web_log.tsv | sort -n -r -k 1 | head -n 10  
}
function Q6 {
	awk -F '\t' '{if($5=="'$1'")sum[$1]+=1} END {for(i in sum){print sum[i],i}}' web_log.tsv | sort -n -r -k 1 | head -n 100

}
function Q7 {
	echo "This is help information"
	echo "Usage: bash WebLog.sh [OPTIONS] [PARAMENTER]"
	echo "-u        求给定url的TOP100访问来源主机，url必须是完整的"
	echo "-o        统计访问来源主机TOP 100和分别对应出现的总次数"
	echo "-i        统计访问来源主机TOP 100 IP和分别对应出现的总次数"
	echo "-f        统计最频繁被访问的URL TOP 100"
	echo "-s        统计不同响应状态码的出现次数和对应百分比"
	echo "-x        分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
	echo "--help    获取帮助信息"
}
while [ "$1" != "" ] ; do 
	case $1 in 
		-u)
		       echo "给定URL的TOP100访问来源主机,必须是完整的URL"	
		       Q6 $2
		       shift 1
		       ;;
		-o)
			echo "统计访问来源主机TOP 100和分别对应出现的总次数"
			Q1
			;;
		-i)
			echo "统计访问来源主机TOP 100 IP和分别对应出现的总次数"
			Q2
			;;
		-f)
			echo "统计最频繁被访问的URL TOP 100"
			Q3
			;;
		-s)
			echo "统计不同响应状态码的出现次数和对应百分比"
			Q4
			;;
		-x)
			echo "分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
			Q5
			;;
		-h|--help)
			Q7
			;;
	esac
	    shift
done

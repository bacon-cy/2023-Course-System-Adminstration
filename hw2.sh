#!/usr/local/bin/bash

#
# functions
#


#usage : print out help message
usage() {
echo -n -e "\nUsage: sahw2.sh {--sha256 hashes ... | --md5 hashes ...}-i files ...\n\n--sha256: SHA256 hashes to validate input files.\n--md5:MD5 hashes to validate input files.\n-i: Input files.\n"
}

#
# parsing options
#

md5=0
sha256=0
filenum=0
hashnum=0
files=()
hashes=()

#沒有給參數
if [ $# -le 0 ]; then
	usage
	exit 1
fi

while getopts "hi:-:" opt; do
	case $opt in
		h) #help
			usage
			exit 0
		;;
		i) #input files
			shift
			while [ $# -gt 0 ] && ! [[ "$1" == -* ]]; do
				files+=("$1")
				filenum=$(( filenum + 1 ))
				shift
			done
		;;
		-) #hashes
		
			#確認hash數量
			case ${OPTARG} in
				md5*)
					echo ${OPTARG}
					md5=1
				;;
				sha256*)
					echo ${OPTARG}
					sha256=1
				;;
				*)
					echo "Error: Invalid arguments." 1>&2
					usage
					exit 1
				;;
			esac

			#輸入hashes
			shift
			while [ $# -gt 0 ] && ! [[ "$1" == -* ]]; do
				echo "$1"
				hashes+=("$1")
				hashnum=$(( hashnum + 1 ))
				shift
			done
		;;
		*) #invaid options inputed
			echo "Error: Invalid arguments." 1>&2
			usage
			exit 1
		;;
	esac
done
			
if [ $md5 -eq 1 ] && [ $sha256 -eq 1 ]; then
	echo "Error: Only one type of hash function is allowed." 1>&2
	exit 3
fi

if [ $hashnum -ne $filenum ]; then
	echo "Error: Invalid values." 1>&2
	exit 2
fi





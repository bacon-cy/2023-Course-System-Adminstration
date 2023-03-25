#!/usr/local/bin/bash -x

#
# functions
#


#usage : print out help message
usage() {
echo -n -e "\nUsage: sahw2.sh {--sha256 hashes ... | --md5 hashes ...} -i files ...\n\n--sha256: SHA256 hashes to validate input files.\n--md5: MD5 hashes to validate input files.\n-i: Input files.\n"
}

#
# Parsing Options
#

md5=0
sha256=0
declare -i filenum=0
declare -i hashnum=0
files=()
hashes=()

#沒有給參數
if [ $# -le 0 ]; then
	usage
	exit 1
fi

while [ "$#" -gt 0 ]; do
	case "$1" in
		-h) #help
			usage
			exit 0
		;;
		-i) #input files
			shift
			while [ $# -gt 0 ] && ! [[ "$1" == -* ]]; do
                files+=("$1")
				filenum=$(( filenum + 1 ))
				shift
			done
		;;
		--md5)
			md5=1
			shift
			while [ $# -gt 0 ] && ! [[ "$1" == -* ]]; do
				hashes+=("$1")
				hashnum=$(( hashnum + 1 ))
				shift
			done
		;;
		--sha256)
			sha256=1
			shift
			while [ $# -gt 0 ] && ! [[ "$1" == -* ]]; do
				hashes+=("$1")
				hashnum=$(( hashnum + 1 ))
				shift
			done
		;;	
		*) #invaid options inputed
			if [[ "$1" != "-md5" ]] || [[ "$1" != "-sha256" ]]; then
			echo -n "Error: Invalid arguments." 1>&2
			usage
			exit 1
			fi
		;;
	esac
done

if [ $hashnum -ne $filenum ]; then
	echo -n "Error: Invalid values." 1>&2
	exit 2
fi
	
if [ $md5 -eq 1 ] && [ $sha256 -eq 1 ]; then
	echo -n "Error: Only one type of hash function is allowed." 1>&2
	exit 3
fi


#
# Hash Validation
#

checksum=0

for i in $(seq 0 $(($filenum- 1))); do
    if [ $md5 -eq 1 ]; then
#        echo "${#files[@]}"
#        echo "${files[$i]}\n"
        cal_hash=`md5sum "${files[$i]}" | awk '{print $1}'`
#        echo ${calculated_hash}
    elif [ $sha256 -eq 1 ]; then
        cal_hash=`sha256sum "${files[$i]}" | awk '{print $1}'`
    fi
    
    #比對cal_hash和hashes[i]是否相同
    if ! [ $cal_hash == ${hashes[$i]} ]; then
#        echo "$cal_hash"
#        echo "${hashes[$i]}"
        echo -n "Error: Invalid checksum." 1>&2
        exit 4
    fi
done


#
# Parsing JSON & CSV
#






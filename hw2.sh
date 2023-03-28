#!/usr/local/bin/bash

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
        cal_hash=`md5sum "${files[$i]}" | awk '{print $1}'`
    elif [ $sha256 -eq 1 ]; then
        cal_hash=`sha256sum "${files[$i]}" | awk '{print $1}'`
    fi
    
    #比對cal_hash和hashes[i]是否相同
    if ! [ $cal_hash == ${hashes[$i]} ]; then
        echo -n "Error: Invalid checksum." 1>&2
        exit 4
    fi
done


#
# Parsing JSON & CSV
#
users=()
password=()
shell=()
groups=()

for i in $(seq 0 $(($filenum - 1))); do
    json=0
    csv=0
    file_content=`cat ${files[$i]}`

    # JSON
    err=`jq -e 'map({username, password, shell, groups})' <${files[$i]} 1>/dev/null 2>&1; echo $?`   
    if [ $err == 0 ]; then
        json=1
    fi
    # CSV
    if [[ ${file_content} =~ ^username,password,shell,groups ]]; then
        csv=1
    fi
    #Check File is valid or not
    if [ $csv == 0 ] && [ $json == 0 ]; then
        echo -n "Error: Invalid file format." 1>&2
        exit 5     
    fi
    #Process CSV
    if ! [ $csv == 0 ]; then    
        users+=`sed -e '1d' ${files[$i]} | awk -F',' '{print $1 " "}'`
        password+=`sed -e '1d' ${files[$i]} | awk -F',' '{print $2 " "}'`
        shell+=`sed -e '1d' ${files[$i]} | awk -F',' '{print $3 " "}'`

    #Process JSON
    else
        users+=`jq '.[] | .username' ${files[$i]} | sed -e 's/\"/ /g'`
        password+=`jq '.[] | .password' ${files[$i]} | sed -e 's/\"/ /g'`
        shell+=`jq '.[] | .shell' ${files[$i]} | sed -e 's/\"/ /g'`
    fi
    
    for u in $user; do
        echo -n "$u"' ' 
    done
done


echo -n 'This script will create the following user(s): '
for u in $users; do
    echo -n "$u"' '
done
echo -n 'Do you want to continue? [y/n]:'

read ans
case $ans in
    n | \n)
        exit 0  
    ;;
    [^y])
        exit 8
esac



#
# Add Users
#






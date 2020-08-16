#!/bin/bash
echo start >> log

# * (I) Initialization
threads=(./thread1 ./thread2 ./thread3 ./thread4 ./thread5)
# threads=(thread1 thread2 thread3 thread4 thread5)
p=5    # p threads
k=6    # 6 serial jobs per thread are allowed
n=$((p * k))       # 30 jobs totally allowed
declare -A idcts   # associative array id-count
cts=(0 0 0 0 0)    # array for count

echo n >> log

# * (II) Count # of files in each thread folder
idx=0
for thread in "${threads[@]}"
do
    shopt -s nullglob
    cd ${thread}
    numfiles=(*)
    numfiles=${#numfiles[@]}
    cd ..

    cts[$idx]=$numfiles
    idcts[${idx}]=${numfiles}
    ((idx += 1))
done

# for thread in "${threads[@]}";do shopt -s nullglob;cd ${thread};numfiles=(*);numfiles=${#numfiles[@]};cd ..;echo ${numfiles};idcts[${idx}]=${numfiles};echo ${!idcts[*]};((idx += 1));echo ${idx};done
# echo ${idcts[*]}



# * (III) Sort ids based on increasing order of cts **
# IFS=$'\n' sorted=($(sort <<<"${idcts[*]}"));unset IFS
# for k in "${!idcts[@]}"; do echo $k ${idcts[$k]};done | sort -rn -k2
mapfile -t arr < <(
    for key in "${!idcts[@]}"
    do
        printf '%d:%d\n' $key ${idcts[$key]}
    done | sort -t : -k 2n
)
# mapfile -t arr < <(for key in "${!idcts[@]}"; do printf '%d:%d\n' $key ${idcts[$key]};done | sort -t : -k 2n)
# echo ${arr[*]}

ids=()
idx=0
IFS=':'
for ele in "${arr[@]}"
do
    read -ra csplit <<< ${ele}
    ids[${idx}]=${csplit[0]}
    # cts[${idx}]=${csplit[1]}
    ((idx += 1))
done

# test
echo ${cts[*]}
echo ${ids[*]}
is=(0 1 2 3 4)
for i in ${is[@]}
do
    echo ${threads[ids[i]]} has ${cts[ids[i]]} files
done

# for ele in "${arr[@]}"; do echo ${ele};read -ra csplit <<< ${ele};ids[${idx}]=${csplit[0]};cts[${idx}]=${csplit[1]};((idx += 1));done
unset IFS


# * (IV) Terminate checking
# ** (i) if no thread available
if ((cts[0] >= k))
then
    exit 1
fi
#if ((cts[4] > 0));then echo yes;fi

# ** (ii)  count # of files nfiles pending to process
# if nfiles == 0 terminate
shopt -s nullglob
cd ./pending
numfiles=(*)
numfiles=${#numfiles[@]}
cd ..
echo ${numfiles} files pending to process


#shopt -s nullglob;cd ./pending;numfiles=(*);numfiles=${#numfiles[@]};cd ..;echo ${numfiles}
if ((numfiles == 0))
then exit 1
fi
# if ((numfiles == 0));then echo yes;fi


echo $numfiles >> log
echo ${cts[*]} >> log


# * (V) Assign jobs to threads/folders
# ** (i) initialize
echo start assign >> log

# cur=(*)
# len=${#cur[@]}

occp=$(IFS=+; echo "$((${cts[*]}))")
ava="$((n - occp))"

echo $occp+$ava >> log

# ** (ii) collect all files in pending and sort in order of creation time
mapfile -t files < <(find ./pending -type f -printf '%T+ %p\n' | sort)
# echo ${files[@]}

echo ${ids[*]}
# ** (iii) assign files to available threads
i=0
for file in "${files[@]}"
do
    # echo ${file}
    dn=${file##* } # extract file dir from file string
    fn=${dn##*/}   # extract fn from dir
    # echo ${fn}
    ((ava <= 0)) && break # if no available slots for jobs break

    while ((ava > 0))
    do
        ((i >= p)) && ((i -= p))
        id=${ids[$i]}

        ((i += 1))
        cthread=${threads[${id}]}
        # echo ${cthread}
        ((cts[id] >= k)) && continue

        dest="${cthread}/${fn}"
        # echo $dn+ $dest >> log
        mv ${dn} ${dest}   # move current file to destination
        ((ava -= 1))
        ((cts[id] += 1))
        break
    done
done
exit 0

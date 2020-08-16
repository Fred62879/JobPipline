#!/bin/bash

time=$1
cthread=$2

echo $cthread running on $$


cd $cthread
while :
do
    numfiles=(*)
    numfiles=${#numfiles[@]}
    ((numfiles == 0)) && sleep $time && continue

    mapfile -t files < <(find ./ -type f -printf '%T+ %p\n' | sort)

    for file in "${files[@]}"
    do
        # * (i) initialize
        dn=${file##* }   # extract file dir from file string
        fn=${dn##*/}     # extract fn from dir
        nidfn=${fn%^*}      # get rid of id
        origfn=${nidfn##*^} # get original file name
        email=${nidfn%^*}   # get email address

        # * (ii) run and get result
        # res=$($dn)
        res=$($dn 2>&1) # error can also be caught
        exitcode=$?
        echo $exitcode
        # echo returned from subscript $res

        # * (iii) send email to customer and delet file
        echo From: Fred82679@gmail.com > email.txt
        echo To: $email >> email.txt
        echo Subject: Result for your job $origfn >> email.txt
        echo "" >> email.txt

        if ! (($exitcode == 0)); then
            echo "ERROR!" >> email.txt
        fi
        echo $res >> email.txt

        sendmail $email < email.txt
        echo send email to $email in $cthread for $origfn with result $res
        # cat email.txt

        rm email.txt
        rm $fn
        # echo remove $fn
    done
    # ((1 == 1)) && break
    sleep $time
    # echo current cycle for $cthread finished
done
cd ..

exit 0

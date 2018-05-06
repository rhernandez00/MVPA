#!/bin/bash


fileName=Atlas.nii.gz

#Cutting in Z
#cutting down
fslsplit ${fileName} z -z

counter=0
names=""
ls z* > imgs
num=57 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -gt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -z AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done


#cutting up
fslsplit AtlasCut.nii.gz z -z

counter=0
names=""
ls z* > imgs
num=160 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -lt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -z AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done


#Cutting in X

#cutting down
fslsplit AtlasCut.nii.gz z -x

counter=0
names=""
ls z* > imgs
num=43 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -gt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -x AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done

#cutting up
fslsplit AtlasCut.nii.gz z -x

counter=0
names=""
ls z* > imgs
num=160 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -lt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -x AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done


#Cutting in Y

#cutting down
fslsplit AtlasCut.nii.gz z -y

counter=0
names=""
ls z* > imgs
num=13 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -gt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -y AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done

#cutting up
fslsplit AtlasCut.nii.gz z -y

counter=0
names=""
ls z* > imgs
num=231 #initial num
for file in $(cat imgs)
do
    counter=`expr $counter + 1`
    if [ ${counter} -lt ${num} ]; then
        #echo ${counter}
        names+=${file}" "
    fi    

done

fslmerge -y AtlasCut.nii.gz ${names}

ls z* > imgs
for file in $(cat imgs)
do
rm ${file}
done



fslview AtlasCut.nii.gz &

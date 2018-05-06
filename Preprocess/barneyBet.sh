#!/bin/bash

fileName=$1

bet=1
x=74
y=76
z=69
thr=0.35
x2=74
y2=159
z2=67
thr2=0.6
initialx=0 #60
finalx=148 #208
initialy=0 #0 #108
finaly=207 #423 #315
initialz=0 #0 #116
finalz=139 #371 #255

#cutting down x
fslsplit ${fileName} slice -x
names=""
for fileNum in $(seq -f "%04g" ${initialx} ${finalx})
do
	file=slice${fileNum}
	names+=${file}" "
done

fslmerge -x mergedFile.nii.gz ${names}

filesToRemove=($(ls slice*))
for fileR in "${filesToRemove[@]}"
do
	rm ${fileR}
done

#cutting down y
fslsplit mergedFile.nii.gz slice -y
names=""
for fileNum in $(seq -f "%04g" ${initialy} ${finaly})
do
	file=slice${fileNum}
	names+=${file}" "
done

fslmerge -y mergedFile.nii.gz ${names}

filesToRemove=($(ls slice*))
for fileR in "${filesToRemove[@]}"
do
	rm ${fileR}
done

#cutting down z
fslsplit mergedFile.nii.gz slice -z
names=""
for fileNum in $(seq -f "%04g" ${initialz} ${finalz})
do
	file=slice${fileNum}
	names+=${file}" "
done

fslmerge -z cut_${fileName}.nii.gz ${names}

filesToRemove=($(ls slice*))
for fileR in "${filesToRemove[@]}"
do
	rm ${fileR}
done

#fslview ${fileName} &
rm mergedFile.nii.gz

if [ "$bet" == "1" ]; then
	echo Bet
	bet cut_${fileName}.nii.gz ${fileName}_brain  -f ${thr} -g 0 -c ${x} ${y} ${z} -m
	bet cut_${fileName}.nii.gz ${fileName}_brain2  -f ${thr2} -g 0 -c ${x2} ${y2} ${z2} -m
	fslmaths ${fileName}_brain_mask -add ${fileName}_brain2_mask ${fileName}_brain_mask
	fslmaths ${fileName}_brain_mask -bin ${fileName}_brain_mask
	fslmaths cut_${fileName}.nii.gz -mul ${fileName}_brain_mask brain_${fileName}.nii.gz

	echo fslview
	fslview cut_${fileName}.nii.gz ${fileName}_brain_mask.nii.gz &
else
	

	echo fslview
	fslview cut_${fileName}.nii.gz
fi
echo fslview


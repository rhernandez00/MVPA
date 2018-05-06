#!/bin/bash

fileName=$1
bet=1
: '
#Struct
x=34
y=41
z=33
thr=0.70
x2=36
y2=42
z2=30
thr2=0.70
initialx=210 #
finalx=280  #268
initialy=77 #0 
finaly=164 #423 
initialz=229 #0 
finalz=315 #371
' 
#BOLD
x=17
y=23
z=16
thr=0.85
x2=17
y2=29
z2=22
thr2=0.9
initialx=21
finalx=55 #78
initialy=22 #0
finaly=66 #94
initialz=19 #0
finalz=60 #77


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


rm mergedFile.nii.gz




if [ "$bet" == "1" ]; then
	echo Bet
	bet cut_${fileName}.nii.gz ${fileName}_brain  -f ${thr} -g 0 -c ${x} ${y} ${z} -m
	bet cut_${fileName}.nii.gz ${fileName}_brain2  -f ${thr2} -g 0 -c ${x2} ${y2} ${z2} -m
	fslmaths ${fileName}_brain_mask -add ${fileName}_brain2_mask ${fileName}_brain_mask
	fslmaths ${fileName}_brain_mask -bin ${fileName}_brain_mask
	fslmaths cut_${fileName}.nii.gz -mul ${fileName}_brain_mask brain_${fileName}.nii.gz

	echo fslview
	fslview cut_${fileName}.nii.gz ${fileName}_brain_mask.nii.gz
	rm ${fileName}_brain.nii.gz
	rm ${fileName}_brain2.nii.gz
	rm ${fileName}_brain2_mask.nii.gz
	rm cut_${fileName}.nii.gz
else
	

	echo fslview
	fslview cut_${fileName}.nii.gz
fi


	

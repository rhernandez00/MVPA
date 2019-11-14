#!/bin/bash



bet=$1 #0 - no bet, 1 - bet

#workingFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogsb
workingFolder=/media/sf_data/Olfactory/Kunkun

cd ${workingFolder}
source /home/brain/Desktop/vals_n_meanfct
fileName=Dog_Kunkun_FunctionalOlf_10_1.nii.gz

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
#	echo ${fileR}
	rm ${fileR}
done


#cp mergedFile.nii.gz cut_${fileName}.nii.gz
rm mergedFile.nii.gz



if [ "$bet" == "1" ]; then
	echo Bet
	bet cut_${fileName}.nii.gz ${fileName}_brain  -f ${thr} -g 0 -c ${x} ${y} ${z} -m
	bet cut_${fileName}.nii.gz ${fileName}_brain2  -f ${thr2} -g 0 -c ${x2} ${y2} ${z2} -m
	if [ "$n_meanfct" == "0" ]; then
		cp ${fileName}_brain_mask.nii.gz ${dataFolder}/${experiment}/data/${sub}/masks/orig/b_fullbrain.nii.gz

	fi
	
	echo fslview
	fslview cut_${fileName}.nii.gz ${fileName}_brain_mask.nii.gz ${fileName}_brain2_mask.nii.gz
fslmaths ${fileName}_brain_mask -add ${fileName}_brain2_mask ${fileName}_brain_mask
	fslmaths ${fileName}_brain_mask -bin ${fileName}_brain_mask
	fslmaths cut_${fileName}.nii.gz -mul ${fileName}_brain_mask brain_${fileName}.nii.gz
	rm ${fileName}_brain.nii.gz
	rm ${fileName}_brain2.nii.gz
	#rm ${fileName}_brain2_mask.nii.gz
#	rm cut_${fileName}.nii.gz
else
	

	echo fslview
	fslview cut_${fileName}.nii.gz
fi


	

#!/bin/bash


sourceFolder=/media/sf_Google_Drive/DeleteProcessDianaProsodia/DianaSeptember2/ToProcess
workingFolder=/media/sf_Google_Drive/DeleteProcessDianaProsodia/DianaSeptember2/A0
bet=$1 #0 - no bet, 1 - bet
valsSource=/home/brain/Desktop/vals_nii

source ${valsSource}

echo ${fileName}


echo getting A0
#fslroi ${sourceFolder}/${fileName} ${workingFolder}/${fileName} 0 1
fslmaths ${sourceFolder}/${fileName} -Tmean ${workingFolder}/${fileName}

cd ${workingFolder}
#cutting down x
echo splitting x
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
echo splitting y
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
echo splitting z
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
	
	
	echo fslview
	fslview cut_${fileName}.nii.gz ${fileName}_brain_mask.nii.gz ${fileName}_brain2_mask.nii.gz
fslmaths ${fileName}_brain_mask -add ${fileName}_brain2_mask ${fileName}_brain_mask
	fslmaths ${fileName}_brain_mask -bin ${fileName}_brain_mask
	fslmaths cut_${fileName}.nii.gz -mul ${fileName}_brain_mask brain_${fileName}.nii.gz
	rm ${fileName}_brain.nii.gz
	rm ${fileName}_brain2.nii.gz
	rm ${fileName}_brain2_mask.nii.gz
	rm cut_${fileName}.nii.gz
else
	

	echo fslview
	fslview cut_${fileName}.nii.gz
fi

cp ${valsSource} vals_${fileName}
	

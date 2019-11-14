#!/bin/bash


experiment=$1
subjNum=$2
n_meanfct=$3 #if the 1 = mc image is used or 0 = m_BOLD meanfct
bet=$4 #0 - no bet, 1 - bet
desk=$5 #copy from 1 Desktop or 0 not
printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}





case "${experiment}" in
	Prosody)
		echo ProsodyFSL
		dataFolder=/media/sf_data
		workingFolder=${dataFolder}/${experiment}/data/${sub}/masks/
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		dataFolder=/media/sf_data/Prosody
		workingFolder=${dataFolder}/NoFM/data/${sub}/masks/
		;;
	SST)
		echo SSTe
		dataFolder=/media/sf_data/SST
		workingFolder=${dataFolder}/data/${sub}/masks/
		;;
	ProsodyFM)
		echo ProsodyFM
		dataFolder=/media/sf_data/Prosody
		workingFolder=${dataFolder}/FM/data/${sub}/masks/
		;;
	ComplexD)
		echo ComplexD
		dataFolder=/media/sf_data/Complex/ComplexD
		workingFolder=${dataFolder}/data/${sub}/masks/
		;;
	FacesD)
		echo FacesD
		dataFolder=/media/sf_data/Faces/facesD
		workingFolder=${dataFolder}/data/${sub}/masks/
		;;
	CEVA)
		echo CEVA
		dataFolder=/media/sf_data/CEVA
		workingFolder=${dataFolder}/data/${sub}/masks
		;;
	Diana)
		echo Diana
		dataFolder=/media/sf_data/Diana
		workingFolder=${dataFolder}/data/${sub}/masks
		;;
	Other)
		echo Other
		workingFolder=/media/sf_data/Prosody/ReorientedAndFM
		;;
	*)
		echo Wrong proyect
		exit 1
esac


cd ${workingFolder}

case "${n_meanfct}" in
	1)
		#mc
		if [ "$desk" == "1" ]; then
			echo Desktop
			source /home/brain/Desktop/vals_n_meanfct
			cp /home/brain/Desktop/vals_n_meanfct ${workingFolder}/vals_n_meanfct
		else
			echo working folder
			source ${workingFolder}/vals_n_meanfct
		fi
	

		fileName=n_meanfct
#		cp /home/brain/Desktop/vals_n_meanfct ${workingFolder}/vals_n_meanfct
		;;
	0)
		if [ "$desk" == "1" ]; then
			echo Desktop
	 		source /home/brain/Desktop/vals_m_BOLD
			cp /home/brain/Desktop/vals_m_BOLD ${workingFolder}/vals_m_BOLD
		else
			echo working folder
			source	${workingFolder}/vals_m_BOLD
		fi


		fileName=m_BOLD
#		cp /home/brain/Desktop/vals_m_BOLD ${workingFolder}/vals_m_BOLD
#		fileName=meanfct #from prosody on
		;;
	2)
		source /home/brain/Desktop/vals_STD
		fileName=OSTD
		;;

	*)
		echo wrong typee of filee
		exit 1
esac


#fileName=$1





echo ${sub} ${experiment} ${fileName}


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
		cp ${fileName}_brain_mask.nii.gz ${dataFolder}/data/${sub}/masks/orig/b_fullbrain.nii.gz


	fi
	
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




	

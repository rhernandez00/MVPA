# ! /bin/bash


dataFolder=/media/sf_Google_Drive/Faces_HuMVPA


subjNum=$1 #corresponding number
nFiles=6
subjIndx=$(($1 - 1)) #corresponding number
printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
task=001 #number of task (this is arbitrary), most of the times it is 001, it could change if in the same experiment the subj underwent different scans of completely different paradigms (not repetitions)
cd ${dataFolder}/data/sub${subjS}/masks
source vals_m_BOLD
for i in $(seq 1 ${nFiles})
do

	printf -v runS "%03d" ${i} #creates the padded number of run
	echo run${runS}
	outFolder=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${runS}
	cd ${outFolder}
	fileName=BOLD
	#cutting down x
	fslsplit ${fileName}.nii.gz slice -x
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
	rm ${fileName}.nii.gz
	cp cut_${fileName}.nii.gz BOLD.nii.gz
	rm cut_${fileName}.nii.gz
done


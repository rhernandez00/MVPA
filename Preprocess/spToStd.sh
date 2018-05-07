#!/bin/bash

experiment=Faces_HuMVPA
dataFolder=/media/sf_Google_Drive
resultsFolder=/media/sf_Google_Drive/Faces_Hu/results
A02StdName=A02std.mat
referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
initualSub=1
finalSub=15

for i in $(seq ${initialSub} ${finalSub})
do
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})

done



declare -a rads=("3" "4")
#declare -a subjects=("sub001")
declare -a models=("2" "3")
#declare -a models=("2")
declare -a tasks=("1")



#for i in {0..65}
#do
	for model in "${models[@]}"
	do
		echo model ${model}
		for task in "${tasks[@]}"
		do
			echo task ${task}
			for r in "${rads[@]}"
			do
				echo radius ${r}
				for subj in "${subjects[@]}"
				do
					echo ${subj}
					flirt -in ${resultsFolder}/task${task}model${model}r${r}${subj}.nii.gz -ref ${referenceFile} -applyxfm -init ${dataFolder}/${experiment}/data/${subj}/masks/${A02StdName} -out ${resultsFolder}/STD/STDtask${task}model${model}r${r}${subj}.nii.gz
					
					#flirt -in ${dataFolder}/task${task}model${model}r${r}${subj}_${i}.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -applyxfm -init /media/sf_usr/share/data/${experiment}/data/${subj}/masks/${A02StdName} -out ${dataFolder}/STD/STDtask${task}model${model}r${r}${subj}_${i}.nii.gz
				done
			done
		done
	done
#done


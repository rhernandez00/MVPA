#!/bin/bash

experiment=Faces_HuMVPA
#experiment=HmFaces
dataFolder=/media/sf_Google_Drive
resultsFolder=/media/sf_results/RSADog
A02StdName=A02std2mm.mat
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
initualSub=1
finalSub=20

initialPair=0
finalPair=23



for i in $(seq ${initialSub} ${finalSub})
do
	echo ${i}
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})

done



declare -a rads=("3")
declare -a pairs=("000_001" "000_002" "000_003" "001_002" "001_003" "002_003")

#declare -a subjects=("sub001")
#declare -a models=("2" "3" "4")
declare -a models=("1")
declare -a tasks=("1")




for pair1 in $(seq ${initialPair} ${finalPair})
do
	for pair2 in $(seq ${initialPair} ${finalPair})
	do
		printf -v pair1S "%03d" ${pair1}
		printf -v pair2S "%03d" ${pair2}
		par=${pair1S}_${pair2S}
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
						echo ${resultsFolder}/task${task}model${model}r${r}${subj}_${par}.nii.gz
						flirt -in ${resultsFolder}/task${task}model${model}r${r}${subj}_${par}.nii.gz -ref ${referenceFile} -applyxfm -init ${dataFolder}/${experiment}/data/${subj}/masks/${A02StdName} -out ${resultsFolder}/STD/STDtask${task}model${model}r${r}${subj}_${par}.nii.gz
					
						#flirt -in ${dataFolder}/task${task}model${model}r${r}${subj}_${i}.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -applyxfm -init /media/sf_usr/share/data/${experiment}/data/${subj}/masks/${A02StdName} -out ${dataFolder}/STD/STDtask${task}model${model}r${r}${subj}_${i}.nii.gz
					done
				done
			done
		done
	done
done


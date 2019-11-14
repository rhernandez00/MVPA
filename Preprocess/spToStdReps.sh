#!/bin/bash

#experiment=Faces_HuMVPA


experiment=dogs
dataFolder=/media/sf_Google_Drive/usr/share/data

#experiment=HmFaces
#dataFolder=/media/sf_Google_Drive
#dataFolder=/media/sf_Google_Drive/usr/share/data


#resultsFolder=/media/sf_results/HumRnd
#resultsFolder=/media/sf_results/DogRnd
#resultsFolder=/media/sf_results/DogRnd
#resultsFolder=/media/sf_Google_Drive/Results/DogEmotionsNeg/rnd
#resultsFolder=/media/sf_Google_Drive/Results/Emotions/Positive
resultsFolder=/media/sf_results/Emotions/Negative
A02StdName=A02std.mat
#A02StdName=A02std2mm.mat
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Datta.nii.gz



#declare -a rads=("2" "3" "4" "5")
declare -a rads=("3")
declare -a subjects=("sub001")
declare -a models=("1")
declare -a tasks=("1")

initialRep=$1
finalRep=$2



for i in $(seq ${initialRep} ${finalRep})
do
printf -v repN "%03d" ${i} #creates the padded number of run
echo ${repN}
	for model in "${models[@]}"
	do
		for task in "${tasks[@]}"
		do
			for r in "${rads[@]}"
			do
				for subj in "${subjects[@]}"
				do

					#flirt -in ${resultsFolder}/av1task${task}model${model}r${r}${subj}.nii.gz -ref ${referenceFile} -applyxfm -init ${dataFolder}/${experiment}/data/${subj}/masks/${A02StdName} -out ${resultsFolder}/STD/model${model}/STDtask${task}model${model}r${r}${subj}.nii.gz
					echo ${resultsFolder}/rndav1task${task}model${model}r${r}${subj}_${repN}.nii.gz
					if [ -f ${resultsFolder}/rndav1task${task}model${model}r${r}${subj}_${repN}.nii.gz ]; then
						echo Working
						flirt -in ${resultsFolder}/rndav1task${task}model${model}r${r}${subj}_${repN}.nii.gz -ref ${referenceFile} -applyxfm -init ${dataFolder}/${experiment}/data/${subj}/masks/${A02StdName} -out ${resultsFolder}/STD/STDtask${task}model${model}r${r}${subj}_${repN}.nii.gz

					fi
				done
			done
		done
	done
done


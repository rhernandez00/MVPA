#!/bin/bash

#experiment=Faces_HuMVPA
#experiment=FacesHm
experiment=facesDog
#experiment=Prosody
#experiment=HmFaces
experiment=dogs
#dataFolder=/media/sf_Google_Drive
dataFolder=/media/sf_Google_Drive/usr/share/data
#dataFolder=/media/sf_data

#resultsFolder=/media/sf_results/Faces/Hum
resultsFolder=/media/sf_results/Faces/Dog
resultsFolder=/media/sf_results/Faces/DogSTD_SPM
resultsFolder=/media/sf_Google_Drive/Results/Emotions/Positive
#resultsFolder=/media/sf_Google_Drive/Results/DogEmotionsNeg
#resultsFolder=/media/sf_Google_Drive/Results/Prosody
#resultsFolder=/media/sf_results/Faces/Hum
#resultsFolder=/media/sf_results/Faces/Dog


A02StdName=A02std.mat
#A02StdName=A02std2mm.mat
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
#referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
referenceFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Datta.nii.gz
initualSub=1
finalSub=4

for i in $(seq ${initialSub} ${finalSub})
do
	echo ${i}
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})
done



declare -a rads=("2" "3" "4" "5")
declare -a rads=("3")
#declare -a subjects=("sub001")
declare -a models=("0" "1" "2")
#declare -a models=("1")
av=1

declare -a tasks=("1")






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
					outDir=${resultsFolder}/STD/model${model}/r${r}/av${av}
					mkdir -p ${outDir}
					echo ${resultsFolder}/av${av}task${task}model${model}r${r}${subj}.nii.gz
					flirt -in ${resultsFolder}/av${av}task${task}model${model}r${r}${subj}.nii.gz -ref ${referenceFile} -applyxfm -init ${dataFolder}/${experiment}/data/${subj}/masks/${A02StdName} -out ${outDir}/STDtask${task}model${model}r${r}${subj}.nii.gz
					#cp ${resultsFolder}/av${av}task${task}model${model}r${r}${subj}.nii.gz ${outDir}/STDtask${task}model${model}r${r}${subj}.nii.gz
					
				done
			done
		done
	done



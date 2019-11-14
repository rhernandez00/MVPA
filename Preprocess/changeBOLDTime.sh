#!/bin/bash

#corrects the time in the BOLD file (after spm it was 1 instead of 3.2)

experiment=facesDogSTD
dataFolder=/media/sf_data

initialSub=19
finalSub=20

for i in $(seq ${initialSub} ${finalSub})
do
	echo ${i}
	printf -v subN "%03d" ${i} #creates the padded number of run
	subjects+=("sub"${subN})

done

#declare -a subjects=("sub001")
declare -a tasks=("1")
declare -a runs=("001" "002" "003" "004" "005" "006")
#declare -a runs=("001")




for task in "${tasks[@]}"
do
	echo task ${task}
	for subj in "${subjects[@]}"
	do
		for run in "${runs[@]}"
		do

			inputFile=${dataFolder}/${experiment}/data/${subj}/BOLD/task00${task}_run${run}/BOLD.nii.gz
			echo ${inputFile}
		  	fslhd -x ${inputFile} > myhdr.txt
			sed -i "s/dt =.*/dt = \'3.2\'/" myhdr.txt
			fslcreatehd myhdr.txt ${inputFile}
		done
	done
done

#!/bin/bash

declare -a runs=("run001" "run002" "run003" "run004")
declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010" "sub011" "sub012" "sub013" "sub014" "sub015" "sub016" "sub017" "sub018" "sub019" "sub020")

for subj in "${subjects[@]}"; do
	for run in "${runs[@]}"; do
		echo running subj:${subj} run:${run}		
		fslview /media/sf_data/Diana/DianaSTD/data/${subj}/BOLD/task001_${run}/BOLD.nii.gz

	done
	wait
done

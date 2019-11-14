#!/bin/bash

#change the type of .fsf

runComplete=true
runs=()
for ((i=1;i<nRuns+1;i++)); do
	printf -v j "%03d\n" $i
	runs+=(run${j})
done


declare -a subjects=("001" "002" "003" "004" "005" "006" "007" "008" "009" "010" "011" "012" "013" "014" "015" "016" "017" "018")
declare -a subjects=("013")
runs=("run001" "run002" "run003" "run004")
combinations=("001" "002" "003" "004" "005" "006" "007" "008" "009" "010" "011" "012" "013" "014" "015" "016" "017" "018" "019" "020" "021" "022" "023" "024" "025" "026" "027" "028" "029")
for subj in "${subjects[@]}"; do
	for run in "${runs[@]}"; do
		for comb in "${combinations[@]}"; do
			echo ${run} 
			
			analyzedFile=/media/sf_data/Prosody/NoFMSTD/data/sub${subj}/BOLD/task001_${run}/BOLD
			echo ${analyzedFile}
			volumes=$(getText.sh ${analyzedFile} vol)
			sed -e "s/subWWW/sub${subj}/g;s/runYYY/${run}/g;s/XXX/${comb}/g;s/VOLUMESVAR/${volumes}/g" /home/brain/Desktop/FSL/SoundDisplacement.fsf > /home/brain/Desktop/FSL/designTmp.fsf
			echo running run:${run} subj:${subj} comb:${comb}
			if [ ${runComplete} = true ] ; then
				echo running fsl
				feat /home/brain/Desktop/FSL/designTmp.fsf
			fi
		done
		wait
	done
done


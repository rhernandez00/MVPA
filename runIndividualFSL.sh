#!/bin/bash

#change the type of .fsf


project=$1
specie=$2
#declare -a subjects=("1" "2" "3" "5" "7" "9" "10")
subjNum=$3 #corresponding number

runComplete=true
#models refers to both, input model to FSL and output model in the FSL results folder
case "${project}" in
	Complex)
		mvpaDataFolder=/media/sf_data/Complex/FSLComplex${specie}STD
		declare -a models=("006")
		fsloutput=/media/sf_results
		projectName=Complex
		fslDesign=ComplexIndividualMean
		;;
	Complex3)
		mvpaDataFolder=/media/sf_data/Complex/FSLComplex${specie}STD
		declare -a models=("006")
		fsloutput=/media/sf_results
		projectName=Complex
		fslDesign=ComplexIndividualMean3
		;;
	*)
		echo Wrong proyect
		exit 1
esac

case "${specie}" in
	D)
		atlas=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm
		;;
	H)
		atlas=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain
		;;
	*)
		echo Wrong specie, accepted are D and H
		exit 1
esac



declare -a tasks=("001")

#for subjNum in "${subjects[@]}"; do
	printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
	subj=sub${subjS}
	for task in "${tasks[@]}"; do
		for model in "${models[@]}"; do
			echo changing .fsf
			echo ${mvpaDataFolder}
			sed -e "s@PROJECT@${projectName}@g;s@ATLASNII@${atlas}@g;s@SPECIE@${specie}@g;s@MVPADATAFOLDER@${mvpaDataFolder}@g;s@00Y@${model}@g;s@FSLOUTPUT@${fsloutput}@g;s@sub00X@${subj}@g" /home/brain/Desktop/FSL/${fslDesign}.fsf > /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${subj}.fsf		
			echo running exp:${project} model:${model} subj:${subj} task:${task}
			if [ ${runComplete} = true ] ; then
				echo running fsl
				feat /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${subj}.fsf
			fi
			wait
		done
	done
#done



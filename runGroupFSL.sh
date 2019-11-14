#!/bin/bash

#change the type of .fsf


project=$1
specie=$2

cope=$3 #corresponding number

runComplete=true
#declare -a copes=("2" "3" "4" "5" "7" "8" "9" "10")
#models refers to both, input model to FSL and output model in the FSL results folder
case "${project}" in
	Complex)
		mvpaDataFolder=/media/sf_data/Complex/FSLComplex${specie}STD
		declare -a models=("006")
		fsloutput=/media/sf_results
		projectName=Complex
		fslDesign=ComplexGroupMean
		;;
	Complex7)
		mvpaDataFolder=/media/sf_data/Complex/FSLComplex${specie}STD
		declare -a models=("006")
		fsloutput=/media/sf_results
		projectName=Complex
		fslDesign=ComplexGroupMean7
		;;
	Complex8)
		mvpaDataFolder=/media/sf_data/Complex/FSLComplex${specie}STD
		declare -a models=("006")
		fsloutput=/media/sf_results
		projectName=Complex
		fslDesign=ComplexGroupMean8
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

#for cope in "${copes[@]}"; do
	for task in "${tasks[@]}"; do
		for model in "${models[@]}"; do
			echo changing .fsf
			echo ${mvpaDataFolder}
			sed -e "s@PROJECT@${projectName}@g;s@ATLASNII@${atlas}@g;s@SPECIE@${specie}@g;s@MVPADATAFOLDER@${mvpaDataFolder}@g;s@00Y@${model}@g;s@FSLOUTPUT@${fsloutput}@g;s@copeX@cope${cope}@g" /home/brain/Desktop/FSL/${fslDesign}.fsf > /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${cope}.fsf		
			echo running exp:${project} model:${model} cope:${cope} task:${task}
			if [ ${runComplete} = true ] ; then
				echo running fsl
				feat /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${cope}.fsf
			fi
			wait
		done
	done
#done



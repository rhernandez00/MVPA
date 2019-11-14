#!/bin/bash




participant=$1 #Miriam
specie=$2 #D or H
proyect=$3


case "${proyect}" in
	CEVA)
		rawFolder=/media/sf_data/CEVA/raw
		outputFolder=/media/sf_data/CEVA/preprocessed
		declare -a runs=("run1")
		
		;;
	Faces)
		rawFolder=/media/sf_data/Faces/raw
		outputFolder=/media/sf_data/Faces/preprocessed
		declare -a runs=("run5" "run6")
#		declare -a runs=("run1")
		;;
	Complex)
		rawFolder=/media/sf_data/Complex/raw
		outputFolder=/media/sf_data/Complex/preprocessed
#		declare -a runs=("run1" "run2" "run3" "run4" "run5" "run6")
		declare -a runs=("run5" "run6")
		;;
	Diana)
		rawFolder=/media/sf_data/Diana/raw
		outputFolder=/media/sf_data/Diana/preprocessed
#		declare -a runs=("run1" "run2" "run3" "run4")
		declare -a runs=("run3" "run4")
		;;
	*)
		echo Wrong proyect
		exit 1
esac


case "${specie}" in
	H)
		reorient=false
		smooth=5
		echo copying anatomic
		cp ${rawFolder}/${participant}_Anatomic.nii.gz ${outputFolder}/${participant}_Anatomic.nii.gz
		;;
	D)
		reorient=true
#		reorient=false
		smooth=5
		;;
	*)
		echo Wrong proyect
		exit 1
esac



#for participant in "${participants[@]}"; do
	for run in "${runs[@]}"; do

		analyzedFile=${rawFolder}/${participant}_${run}.nii.gz
		outputPath=${outputFolder}/${participant}_${run}
		echo ${analyzedFile}
		echo deleting old feat
		rm -r ${outputPath}.feat
		echo deleting nifti
		rm ${outputPath}.nii.gz
		./preprocessFile.sh $analyzedFile $outputPath $smooth $reorient ${participant}



	done
#done


# ! /bin/bash

proyect=$1
subjNum=$2 #corresponding number

case "${proyect}" in
	CEVA)
		echo CEVA
		outputFolder=/media/sf_Google_Drive/Complex/CEVA
		dataFolder=/media/sf_data/CEVA
		declare -a subjects=("Odin1" "Odin2" "Kun1" "Kun2")
		declare -a maskList=("R_gaCinguli.nii.gz" "L_gaCinguli.nii.gz" "R_Amygdala.nii.gz" "L_Amygdala.nii.gz")
		;;
	*)
		echo Wrong proyect
		exit 1
esac

subjIndx=$((${subjNum} - 1)) #corresponding number
subjName=${subjects[${subjIndx}]} #subj to organize
printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
echo ${subjName}

mkdir ${outputFolder}/${subjName}/
for mask in "${maskList[@]}"; do
	echo ${mask}
	cp ${dataFolder}/data/sub${subjS}/masks/orig/${mask} ${outputFolder}/${subjName}/${mask}
	fslswapdim ${outputFolder}/${subjName}/${mask} -x -z y ${outputFolder}/${subjName}/${mask}
done


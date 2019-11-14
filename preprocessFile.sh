#!/bin/bash

runComplete=true
analyzedFile=$1
outputPath=$2
smooth=$3
reorient=$4
participant=$5

volumes=$(getText.sh ${analyzedFile} vol)
TR=$(getText.sh ${analyzedFile} TR)
echo changing .fsf

sed -e "s@OUTPUTPATH@${outputPath}@g;s@VOLUMESVAR@${volumes}@g;s@TRVAR@${TR}@g;s@SMOOTHVAL@${smooth}@g;s@00Y@${model}@g;s@FILEINPUT@${analyzedFile}@g" /home/brain/Desktop/MVPA/preprocess.fsf > /home/brain/Desktop/MVPA/designTmp${participant}.fsf

if [ ${runComplete} = true ] ; then
	echo running fsl
	feat /home/brain/Desktop/MVPA/designTmp${participant}.fsf
fi
wait


funcFile=${outputPath}.feat/filtered_func_data.nii.gz
echo ${outputPath}.nii.gz
cp ${funcFile} ${outputPath}.nii.gz
if [ ${reorient} = true ] ; then
	echo deleting orientation
	fslorient -deleteorient ${outputPath}.nii.gz
	echo swapdim
	fslswapdim ${outputPath}.nii.gz -x z -y ${outputPath}.nii.gz #Prosody
#	fslswapdim ${outputPath}.nii.gz -x -z -y ${outputPath}.nii.gz #FacesMx Zilla
#	fslswapdim ${outputPath}.nii.gz x -z y ${outputPath}.nii.gz #FacesMx Odin
#	fslswapdim ${outputPath}.nii.gz x -z y ${outputPath}.nii.gz #FacesMx Odin 5,6
	echo adding labels
	fslorient -setsformcode 1 -setqformcode 1 ${outputPath}.nii.gz
fi



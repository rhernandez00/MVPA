#!/bin/bash


#subjNum=$1


case "${proyect}" in
	HmFaces) #files have changed, this has to be updated
		dataFolder=/media/sf_Google_Drive
		experiment=HmFaces
		A0=m_BOLD.nii.gz #A0.nii.gz
		;;
	ComplexH)
		dataFolder=/media/sf_data/Complex/ComplexH/
	*)
		echo Wrong proyect
		exit 1
esac


atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz

for subjNum in $(seq 1 2)
do

	printf -v subjS "%03d" ${subjNum}
	sub=sub${subjS}
	echo ${sub}
	#Transforma la anatomica en estandar
	echo anatomic to std
	flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/Anatomic_brain.nii.gz -out ${dataFolder}/${experiment}/data/${sub}/masks/AnatomicSTD.nii.gz -ref ${atlasFile} -omat ${dataFolder}/${experiment}/data/${sub}/masks/A0std1.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 

	#Transforma el volumen 1 a la anatomica
	echo A0 to anatomic...
	flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${A0} -out ${dataFolder}/${experiment}/data/${sub}/masks/A0Anatomic.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/Anatomic_brain.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/A0std2.mat -bins 256 -cost corratio -searchrx -45 45 -searchry -45 45 -searchrz -45 45 -dof 12 

	#Une las matrices de las dos transformaciones
	echo adding the matrices...
	/usr/share/fsl/5.0/bin/convert_xfm -concat ${dataFolder}/${experiment}/data/${sub}/masks/A0std1.mat -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat ${dataFolder}/${experiment}/data/${sub}/masks/A0std2.mat

	#Transforma el volumen 1 a la estandard
	echo A0 to std...
	flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${A0} -ref ${atlasFile} -out ${dataFolder}/${experiment}/data/${sub}/masks/A0std.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat -interp trilinear

	#Invierte la matriz de transformacion
	echo final inversion...
	convert_xfm -omat ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat
done





#!/bin/bash




proyect=$1
subjNum=$2

case "${proyect}" in
	FacesH)
		dataFolder=/media/sf_data/Faces/facesH
		;;
	ComplexH)
		dataFolder=/media/sf_data/Complex/ComplexH
		;;
	*)
		echo Wrong proyect
		exit 1
esac

A0=m_BOLD.nii.gz #base volume
atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain.nii.gz

#for subjNum in $(seq 1 2)
#do

	printf -v subjS "%03d" ${subjNum}
	sub=sub${subjS}
	echo ${sub}
	
	echo BET
	bet ${dataFolder}/data/${sub}/masks/Anatomic ${dataFolder}/data/${sub}/masks/Anatomic_brain -f 0.5 -g 0
	
	#Transforma la anatomica en estandar
	echo anatomic to std
	flirt -in ${dataFolder}/data/${sub}/masks/Anatomic_brain.nii.gz -out ${dataFolder}/data/${sub}/masks/AnatomicSTD.nii.gz -ref ${atlasFile} -omat ${dataFolder}/data/${sub}/masks/A0std1.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 

	#Transforma el volumen base a la anatomica
	echo A0 to anatomic...
	flirt -in ${dataFolder}/data/${sub}/masks/${A0} -out ${dataFolder}/data/${sub}/masks/A0Anatomic.nii.gz -ref ${dataFolder}/data/${sub}/masks/Anatomic_brain.nii.gz -omat ${dataFolder}/data/${sub}/masks/A0std2.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp trilinear




	#Une las matrices de las dos transformaciones
	echo adding the matrices...
	/usr/share/fsl/5.0/bin/convert_xfm -concat ${dataFolder}/data/${sub}/masks/A0std1.mat -omat ${dataFolder}/data/${sub}/masks/A02std.mat ${dataFolder}/data/${sub}/masks/A0std2.mat

	#Transforma el volumen base a la estandard
	echo A0 to std...
	flirt -in ${dataFolder}/data/${sub}/masks/${A0} -ref ${atlasFile} -out ${dataFolder}/data/${sub}/masks/A0std.nii.gz -applyxfm -init ${dataFolder}/data/${sub}/masks/A02std.mat -interp trilinear

	#Invierte la matriz de transformacion
	echo final inversion...
	convert_xfm -omat ${dataFolder}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/data/${sub}/masks/A02std.mat
#done





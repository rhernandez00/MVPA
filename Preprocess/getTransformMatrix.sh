#!/bin/bash

proyect=$1
subjNum=$2

ctod=7 #parameter for transformation
case "${proyect}" in
	Prosody)
		echo ProsodyFSL
		dataFolder=/media/sf_data
		experiment=ProsodyFSL
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		dataFolder=/media/sf_data/Prosody
		experiment=NoFM
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	SST)
		echo SST
		dataFolder=/media/sf_data
		experiment=SST
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		ctod=12
		;;
	ProsodyFM)
		echo ProsodyFM
		dataFolder=/media/sf_data/Prosody
		experiment=FM
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	ComplexD)
		echo ComplexD
		dataFolder=/media/sf_data/Complex/ComplexD
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	FacesD)
		echo FacesD
		dataFolder=/media/sf_data/Faces/FacesD
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	CEVA)
		echo CEVA
		dataFolder=/media/sf_data/CEVA
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	Diana)
		echo Diana
		dataFolder=/media/sf_data/Diana
		atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz
		mBOLD=m_BOLD
		nMeanfct=n_meanfct
		brain_nMeanfct=brain_n_meanfct
		;;
	*)
		echo Wrong proyect
		exit 1
esac




#A - m_BOLD, B - n_meanfct, C - brain_n_meanfct, D - atlas

printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}
echo ${sub}
echo from ${mBOLD} to n_meanfct #A->B
flirt -in ${dataFolder}/data/${sub}/masks/${mBOLD}.nii.gz -ref ${dataFolder}/data/${sub}/masks/${nMeanfct}.nii.gz -out ${dataFolder}/data/${sub}/masks/a_meanfct.nii.gz -omat ${dataFolder}/data/${sub}/masks/meanfct2n_meanfct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

echo brain to n_mean #C->B
#flirt -in ${dataFolder}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -ref ${dataFolder}/data/${sub}/masks/${nMeanfct}.nii.gz -out ${dataFolder}/data/${sub}/masks/braina_n_meanfct.nii.gz -omat ${dataFolder}/data/${sub}/masks/brain2n_meanfct.mat -bins 256 -cost corratio -searchrx -30 30 -searchry -30 30 -searchrz -30 30 -dof 7  -interp trilinear

flirt -in ${dataFolder}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -ref ${dataFolder}/data/${sub}/masks/${nMeanfct}.nii.gz -out ${dataFolder}/data/${sub}/masks/braina_n_meanfct.nii.gz -omat ${dataFolder}/data/${sub}/masks/brain2n_meanfct.mat -bins 256 -cost corratio -searchrx -5 5 -searchry -5 5 -searchrz -5 5 -dof 6  -interp trilinear

echo inverting brain2n_mean #C->B B->C
convert_xfm -omat ${dataFolder}/data/${sub}/masks/n_meanfct2brain_nmean.mat -inverse ${dataFolder}/data/${sub}/masks/brain2n_meanfct.mat

#echo testing n_mean2brain... #B->C
#flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${nMeanfct}.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2brain_nmean.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/n_meanBrain.nii.gz

echo adding the matrices... #A->B + B->C = A->C
convert_xfm -concat ${dataFolder}/data/${sub}/masks/n_meanfct2brain_nmean.mat -omat ${dataFolder}/data/${sub}/masks/meanfct2brain.mat ${dataFolder}/data/${sub}/masks/meanfct2n_meanfct.mat

#echo testing meanfct2brain... #A->C 
#flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${mBOLD}.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/meanfct2brain.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/meanfctBrain.nii.gz

#echo testing n_mean2brain... #B->C
#flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${nMeanfct}.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2brain_nmean.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/borrar.nii.gz

echo from brain_n_meanfct to atlas #C->D
flirt -in ${dataFolder}/data/${sub}/masks/${brain_nMeanfct}.nii.gz -ref ${atlasFile} -out ${dataFolder}/data/${sub}/masks/brainSTD.nii.gz -omat ${dataFolder}/data/${sub}/masks/brain2STD.mat -bins 256 -cost corratio -searchrx -45 45 -searchry -45 45 -searchrz -45 45 -dof ${ctod}  -interp trilinear

echo adding the matrices... #A->C + C->D = A->D
convert_xfm -concat ${dataFolder}/data/${sub}/masks/brain2STD.mat -omat ${dataFolder}/data/${sub}/masks/A02std.mat ${dataFolder}/data/${sub}/masks/meanfct2brain.mat

echo transforming ${mBOLD} to atlas... # A->D
flirt -in ${dataFolder}/data/${sub}/masks/${mBOLD}.nii.gz -ref ${atlasFile} -applyxfm -init ${dataFolder}/data/${sub}/masks/A02std.mat -out ${dataFolder}/data/${sub}/masks/${mBOLD}std.nii.gz

#echo transforming borrar to atlas... #C->D
#flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/meanfctBrain.nii.gz -ref ${atlasFile} -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/brain2STD.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/borrarstd.nii.gz

#from brain_m_BOLD to m_BOLD
flirt -in ${dataFolder}/data/${sub}/masks/brain_${mBOLD}.nii.gz -ref ${dataFolder}/data/${sub}/masks/${mBOLD}.nii.gz -out ${dataFolder}/data/${sub}/masks/brain_mask_${mBOLD}.nii.gz -bins 256 -cost corratio -searchrx -5 5 -searchry -5 5 -searchrz -5 5 -dof 6  -interp trilinear
fslmaths ${dataFolder}/data/${sub}/masks/brain_mask_${mBOLD}.nii.gz -bin ${dataFolder}/data/${sub}/masks/brain_mask_${mBOLD}.nii.gz

echo inverting the matrix #D->A
convert_xfm -omat ${dataFolder}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/data/${sub}/masks/A02std.mat

fslview ${dataFolder}/data/${sub}/masks/${mBOLD}std.nii.gz ${atlasFile}

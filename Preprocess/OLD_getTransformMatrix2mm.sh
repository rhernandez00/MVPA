#!/bin/bash


subjNum=$1
dataFolder=/media/sf_Google_Drive
experiment=Faces_HuMVPA
labelsFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/LABL_Barney2mm.nii.gz
atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm.nii.gz


printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_n_meanfct.nii.gz -ref ${atlasFile} -omat ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2std2mm.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 7  -interp trilinear

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_m_BOLD.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/brain_n_meanfct.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02n_meanfct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

echo adding the matrices...
/usr/share/fsl/5.0/bin/convert_xfm -concat ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2std2mm.mat -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02std2mm.mat ${dataFolder}/${experiment}/data/${sub}/masks/A02n_meanfct.mat

convert_xfm -omat ${dataFolder}/${experiment}/data/${sub}/masks/std2mm2A0.mat -inverse ${dataFolder}/${experiment}/data/${sub}/masks/A02std2mm.mat

echo transforming mask...
flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_m_BOLD.nii.gz -ref ${atlasFile} -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/A02std2mm.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/A0std2mm.nii.gz

#fslview ${dataFolder}/${experiment}/data/${sub}/masks/A0std2mm.nii.gz ${labelsFile}
echo ...Done







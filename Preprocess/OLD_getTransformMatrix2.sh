#!/bin/bash


subjNum=$1
dataFolder=/media/sf_data
experiment=facesDog
labelsFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_LABL_brain_Barney.nii.gz
#labelsFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/LABL_Barney1mm.nii.gz
atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/brain_TPL_brain_Barney.nii.gz
#atlasFile=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Barney1mm.nii.gz
mBOLD=m_BOLD
#mBOLD=meanfct

printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_n_meanfct.nii.gz -ref ${atlasFile} -out ${dataFolder}/${experiment}/data/${sub}/masks/a_brain_n_meanfct.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2std.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 7  -interp trilinear

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_${mBOLD}.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/brain_n_meanfct.nii.gz -out ${dataFolder}/${experiment}/data/${sub}/masks/a_brain_${mBOLD}.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02n_meanfct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

echo adding the matrices...
/usr/share/fsl/5.0/bin/convert_xfm -concat ${dataFolder}/${experiment}/data/${sub}/masks/n_meanfct2std.mat -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat ${dataFolder}/${experiment}/data/${sub}/masks/A02n_meanfct.mat

convert_xfm -omat ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat

echo transforming mask...
flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_${mBOLD}.nii.gz -ref ${atlasFile} -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/A0std.nii.gz

fslview ${dataFolder}/${experiment}/data/${sub}/masks/A0std.nii.gz ${labelsFile}







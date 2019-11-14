#!/bin/bash


subjNum=$1
dataFolder=/media/sf_Google_Drive
experiment=Faces_HuMVPA

printf -v subjS "%03d" ${subjNum}
sub=sub${subjS}

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_n_meanfct.nii.gz -ref /home/brain/Desktop/Preprocess/brain_TPL_brain_Barney.nii.gz -out ${dataFolder}/${experiment}/data/${sub}/masks/a_brain_n_meanfct.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/a_brain_n_meanfct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 7  -interp trilinear

flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/brain_m_BOLD.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/a_brain_n_meanfct.nii.gz -out ${dataFolder}/${experiment}/data/${sub}/masks/am_brain_${fileName}.nii.gz -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

fslview ${dataFolder}/${experiment}/data/${sub}/masks/am_brain_${fileName}.nii.gz /home/brain/Desktop/Preprocess/brain_LABL_brain_Barney.nii.gz

convert_xfm -omat ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat

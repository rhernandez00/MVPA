#!/bin/bash

sub=sub009
experiment=objetos
maskFolder=/home/brain/Desktop/mascarasClase
anatomicName=Anatomica.nii.gz
dataFolder=/media/sf_usr/share/data
maskNameOut=pruebaOut.nii.gz
maskName=AIP.nii.gz

#Obtiene el volumen 1 de la primera adquisicion
echo ${sub}
fslroi ${dataFolder}/${experiment}/data/${sub}/BOLD/task001_run001/BOLD.nii.gz ${dataFolder}/${experiment}/data/${sub}/masks/A0.nii.gz 0 1

#Transforma la anatomica en estandar
echo anatomic to std
/usr/share/fsl/5.0/bin/flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/${anatomicName} -ref /usr/share/fsl/5.0/data/standard/MNI152_T1_2mm_brain -omat ${dataFolder}/${experiment}/data/${sub}/masks/A0std1.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 

#Transforma el volumen 1 a la anatomica
echo A0 to anatomic...
/usr/share/fsl/5.0/bin/flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/A0.nii.gz -ref ${dataFolder}/${experiment}/data/${sub}/masks/${anatomicName} -omat ${dataFolder}/${experiment}/data/${sub}/masks/A0std2.mat -bins 256 -cost corratio -searchrx -45 45 -searchry -45 45 -searchrz -45 45 -dof 12 

#Une las matrices de las dos transformaciones
echo adding the matrices...
/usr/share/fsl/5.0/bin/convert_xfm -concat ${dataFolder}/${experiment}/data/${sub}/masks/A0std1.mat -omat ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat ${dataFolder}/${experiment}/data/${sub}/masks/A0std2.mat

#Transforma el volumen 1 a la estandard
echo A0 to std...
/usr/share/fsl/5.0/bin/flirt -in ${dataFolder}/${experiment}/data/${sub}/masks/A0.nii.gz -ref /usr/share/fsl/5.0/data/standard/MNI152_T1_2mm_brain -out ${dataFolder}/${experiment}/data/${sub}/masks/A0std.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat -interp trilinear

#Invierte la matriz de transformacion
echo final inversion...
convert_xfm -omat ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -inverse ${dataFolder}/${experiment}/data/${sub}/masks/A02std.mat

echo transforming mask...
flirt -in ${maskFolder}/${maskName} -ref ${dataFolder}/${experiment}/data/${sub}/masks/A0.nii.gz -applyxfm -init ${dataFolder}/${experiment}/data/${sub}/masks/std2A0.mat -out ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut}

echo binarizing mask...
fslmaths ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut} -bin ${dataFolder}/${experiment}/data/${sub}/masks/orig/${maskNameOut}

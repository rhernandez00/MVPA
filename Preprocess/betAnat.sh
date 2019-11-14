#!/bin/bash



for sub in $(seq 1 32)
do
	printf -v subjS "%03d" ${sub} #creates the padded number of run
	echo ${subjS}
	fslreorient2std /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/A0.nii.gz /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/A0.nii.gz
	fslreorient2std /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/m_BOLD.nii.gz /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/m_BOLD.nii.gz
	for run in $(seq 1 6)
	do
		echo ${run}
		printf -v runS "%03d" ${run} #creates the padded number of run
#		echo /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLD.nii.gz
		echo creating copy...
		mv /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLD.nii.gz /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLDr.nii.gz
		echo reorienting...
		fslreorient2std /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLDr.nii.gz /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLD.nii.gz
		rm /media/sf_Google_Drive/HmFaces/data/sub${subjS}/BOLD/task001_run${runS}/BOLDr.nii.gz
	done
	#bet /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/AnatomicR /media/sf_Google_Drive/HmFaces/data/sub${subjS}/masks/Anatomic_brain  -f 0.5 -g 0

done


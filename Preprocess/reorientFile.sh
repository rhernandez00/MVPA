# ! /bin/bash

folder=/media/sf_Google_Drive/Faces_Hu/semirawData/Zilla
declare -a fileNames=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz" "run5.nii.gz" "run6.nii.gz")

for fileName in "${fileNames[@]}"
do
	echo ${folder}/${fileName}
	fslorient -deleteorient ${folder}/${fileName}
	echo swapdim
	fslswapdim ${folder}/${fileName} x -z y ${folder}/b_${fileName}
	echo orient
	fslorient -setsformcode 1 -setqformcode 1 ${folder}/b_${fileName}
done

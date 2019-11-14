# ! /bin/bash


folder=/media/sf_data/Reorienting/Morante
comparison=Type2.nii.gz
#declare -a fileNames=("Type1.nii.gz" "Type4.nii.gz")
declare -a fileNames=("Type1.nii.gz" "Type4.nii.gz")

for fileName in "${fileNames[@]}"
do
	echo ${folder}/${fileName}
	cp ${folder}/${fileName} ${folder}/b${fileName}
#	fslorient -deleteorient ${folder}/b${fileName}
	echo swapdim
	fslswapdim ${folder}/b${fileName} -x -y z ${folder}/b${fileName}
#	echo orient
#	fslorient -setsformcode 1 -setqformcode 1 ${folder}/b${fileName}
#	fslview ${folder}/b${fileName} &
#	fslview ${folder}/${comparison}
done



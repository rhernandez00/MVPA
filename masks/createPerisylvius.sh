# ! /bin/bash

maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/LabelsNums2mmStrict
initialNum=18
finalNum=33

cp ${maskFolder}/00.nii.gz ${maskFolder}/b_PerisylviusStrict.nii.gz
for labelNum in $(seq ${initialNum} ${finalNum})
do
	printf -v labelStr "%02d" ${labelNum} #creates the padded number of mask
	echo ${labelStr}
	fslmaths ${maskFolder}/b_PerisylviusStrict -add ${maskFolder}/${labelStr} ${maskFolder}/b_PerisylviusStrict
done

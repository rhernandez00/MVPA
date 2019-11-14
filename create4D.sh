# ! /bin/bash
dataFolder=/media/sf_data/Prosody/soundTest/4D
names=""
for fileNum in $(seq -f "%03g" 1 29)
do
	
	fileN=${dataFolder}/${fileNum}.nii.gz
	#echo $fileN
	names+=${fileN}" "
done


fslmerge -t ${dataFolder}/timelapse.nii.gz ${names}

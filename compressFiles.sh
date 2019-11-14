# ! /bin/bash
cd /media/sf_Google_Drive/Complex/data/niiTransmission
#cd /media/sf_Google_Drive/DeleteProcessDianaProsodia/DianaSeptember2
#cd /media/sf_Google_Drive/Complex/CEVA/dataTransfer

#folderList=($(ls DH* -d))
#declare -a folderList=("Odin" "Maya")
#folder=("/media/sf_data/SST/Raw")
#for name in "${folder[@]}"
#do
#	echo ${name}
#	cd ${name}
	fileList=($(ls *.nii))
	for fileName in "${fileList[@]}"
	do
		gzip ${fileName}
		echo ${fileName} was compressed
	done
	cd ..

#done



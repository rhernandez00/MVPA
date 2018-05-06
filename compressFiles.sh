# ! /bin/bash
cd /media/sf_Google_Drive/Faces_Hu/
#folderList=($(ls -d -- */))
declare -a folderList=("Kun")
for name in "${folderList[@]}"
do
	echo ${name}
	cd ${name}
	fileList=($(ls ))
	for fileName in "${fileList[@]}"
	do
		gzip ${fileName}
		echo ${fileName} was compressed
	done
	cd ..

done



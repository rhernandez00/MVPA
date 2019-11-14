# ! /bin/bash
cd /media/sf_Google_Drive/HumanData/
folderList=($(ls -d DH*))
#declare -a folderList=("Kun")
for name in "${folderList[@]}"
do
	echo ${name}
	cd ${name}
	fileList=($(ls ))
	for fileName in "${fileList[@]}"
	do
		newName=$(echo ${fileName}| cut -d'_' -f 4)
		mv ${fileName} ${newName}
		echo ${newName}
	done
	cd ..

done



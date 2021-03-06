# ! /bin/bash

proyect=$1
specie=$2
subjNum=$3
subjFolder=$4
case "${proyect}" in
	Complex)
		echo Complex
		inputFolder=/media/sf_data/Complex/preprocessed
		dataFolder=/media/sf_data/Complex/Complex${specie}
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz" "run5.nii.gz" "run6.nii.gz")
#		specie=Dog
		;;
	*)
		echo Wrong proyect
		exit 1
esac



#for subjNum in $(seq 1 1)
#do
	subjIndx=$((${subjNum} - 1)) #corresponding number
	echo ${subjNum}
#	subjFolder=$(getName.sh ${specie} ${subjNum})

#	subjFolder=${subjects[${subjIndx}]} #subj to organize

	printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
	nFiles=${#fileList[@]} #gets the number of files in the folder
	task=001 #number of task (this is arbitrary), most of the times it is 001, it could change if in the same experiment the subj underwent different scans of completely different paradigms (not repetitions)

	echo creating ${subjFolder} directories
	mkdir ${dataFolder}/data/sub${subjS} -p -v #creates the directory for the subj
	mkdir ${dataFolder}/data/sub${subjS}/masks -p -v #creates the folder for the masks and A0
	mkdir ${dataFolder}/data/sub${subjS}/masks/orig -p -v #creates the folder for the masks and A0
	echo getting A0
	fslroi ${inputFolder}/${subjFolder}_${fileList[0]} ${dataFolder}/data/sub${subjS}/masks/A0.nii.gz 0 1 #gets the first volume of the first scan
	echo ${subjFolder}
	for i in $(seq 1 ${nFiles})
	do
		printf -v runS "%03d" ${i} #creates the padded number of run
		echo creating directory fOr run...
		inputFile=${inputFolder}/${subjFolder}_run${i}.nii.gz
		outFolder=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${runS}
#		mkdir ${outFolder} -p -v

#		cp ${inputFile} ${outFolder}/uncorrected.nii.gz #creates a copy of the file in the corresponding folder
#		mcflirt -in ${outFolder}/uncorrected.nii.gz -r ${dataFolder}/data/sub${subjS}/masks/A0.nii.gz -out ${outFolder}/BOLD.nii.gz -report
#		rm ${outFolder}/uncorrected.nii.gz
#		fslmaths ${outFolder}/BOLD.nii.gz -Tmean ${outFolder}/m_BOLD.nii.gz
	done


	echo getting the mean img...	
	names=""
	for fileNum in $(seq -f "%03g" 1 ${nFiles})
	do
		file=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${fileNum}/m_BOLD.nii.gz
		names+=${file}" "
	done

#	fslmerge -t ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${names}
#	fslmaths ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz -Tmean ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz
#	cp ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${inputFolder}/meanfct_${subjFolder}.nii.gz
#done
#cp ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${dataFolder}/data/sub${subjS}/masks/meanfct.nii.gz
#rm ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz

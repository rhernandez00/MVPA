# ! /bin/bash

inputFolder=/media/sf_Google_Drive/Faces_Hu
dataFolder=/media/sf_Google_Drive/Faces_HuMVPA

subjFolder=Akira #subj to organize
subjNum=1 #corresponding number
printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
fileList=($(ls ${inputFolder}/${subjFolder})) #makes a list of the files in the folder
nFiles=${#fileList[@]} #gets the number of files in the folder
task=001 #number of task (this is arbitrary), most of the times it is 001, it could change if in the same experiment the subj underwent different scans of completely different paradigms (not repetitions)
echo ${nFiles}

mkdir ${dataFolder}/data/sub${subjS} -p -v #creates the directory for the subj
for i in $(seq 1 ${nFiles})
do
	printf -v runS "%03d" ${i} #creates the padded number of run
	echo creating directory fOr run...
	inputFile=${inputFolder}/${subjFolder}/run${i}.nii.gz
	outFolder=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${runS}
	mkdir ${outFolder} -p -v
	cp ${inputFile} ${outFolder}/uncorrected.nii.gz #creates a copy of the file in the corresponding folder
	
done


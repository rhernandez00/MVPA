# ! /bin/bash

project=$1
subjNum=$2 #corresponding number

case "${project}" in
	Prosody)
		echo Prosody
		inputFolder=/media/sf_data/ProsodyRawFSL/Reoriented
		dataFolder=/media/sf_data/ProsodyFSL
		declare -a subjects=("Odin" "Maya" "Kunkun" "Bran" "Bingo" "Alma" "Bodza" "Sander" "Akira" "Barack" "Grog" "Maverick" "Monty" "Pan" "Barney" "Dome" "Joey" "Mini") #for Bran I used
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz")
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		inputFolder=/media/sf_data/Prosody/Raw/ReorientedNoFM
		dataFolder=/media/sf_data/Prosody/NoFM
		declare -a subjects=("Odin" "Maya" "Kunkun" "Bran" "Bingo" "Alma" "Bodza" "Sander" "Akira" "Barack" "Grog" "Maverick" "Monty" "Pan" "Barney" "Dome" "Joey" "Mini") #for Bran I used
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz")
		;;
	ProsodyFM)
		echo ProsodyFM
		inputFolder=/media/sf_data/Prosody/ReorientedAndFM
		dataFolder=/media/sf_data/Prosody/FM
		declare -a subjects=("Odin" "Maya" "Kunkun" "Bran" "Bingo" "Alma" "Bodza" "Sander" "Akira" "Barack" "Grog" "Maverick" "Monty" "Pan" "Barney" "Dome" "Joey" "Mini") #for Bran I used
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz")
		;;
	SST)
		echo SST
		inputFolder=/media/sf_data/SST/Raw/Reoriented
		dataFolder=/media/sf_data/SST
		declare -a subjects=("akira" "apacs" "barack" "barney" "bingo" "bodza" "bran" "floyd" "grog" "kamilla" "kefir" "kope" "maverick" "maya" "nia" "sander" "walter" "dome" "luna" "molly")
		declare -a fileList=("run1.nii.gz" "run2.nii.gz")
		;;
	ComplexH)
		echo Complex human
		inputFolder=/media/sf_data/Complex/preprocessed
		projectName=Complex
		dataFolder=/media/sf_data/Complex/ComplexH
		declare -a subjects=("Raul" "Laura" "Juan" "Miriam" "Paula" "Cecilia" "Lili" "Rita" "Eszter" "Yago" "Andrea" "John" "Eniko")
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz" "run5.nii.gz" "run6.nii.gz")
		;;
	ComplexD)
		echo Complex dog
		inputFolder=/media/sf_data/Complex/preprocessed
		projectName=Complex
		dataFolder=/media/sf_data/Complex/ComplexD
		declare -a subjects=("Odin" "Kun" "Maya" "Maverick" "Mokka" "Alma" "Akira" "Pan" "Monty" "Kara" "Bodza" "Grog")
#		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz" "run5.nii.gz" "run6.nii.gz")
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz")
		;;
	FacesD)
		echo Faces dog
		inputFolder=/media/sf_data/Faces/preprocessed
		dataFolder=/media/sf_data/Faces/facesD
		declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010" "sub011" "sub012" "sub013" "sub014" "sub015" "sub016" "sub017" "sub018" "sub019" "sub020")
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz" "run5.nii.gz" "run6.nii.gz")
		;;
	CEVA)
		echo CEVA
		inputFolder=/media/sf_data/CEVA/preprocessed
		dataFolder=/media/sf_data/CEVA
		declare -a subjects=("Odin1" "Odin2" "Kun1" "Kun2")
		declare -a fileList=("run1.nii.gz")
		;;
	Diana)
		echo Diana
		inputFolder=/media/sf_data/Diana/preprocessed
		dataFolder=/media/sf_data/Diana
		declare -a subjects=("Akira" "Alma" "Bodza" "Bran" "Demi" "Dome" "Kara" "Kosza" "Kunkun" "Maverick" "Maya" "Mirza" "Mokka" "Monty" "Nara" "Nia" "Odin" "Pan" "Pax" "Sander")
		declare -a fileList=("run1.nii.gz" "run2.nii.gz" "run3.nii.gz" "run4.nii.gz")
		;;
	*)
		echo Wrong project
		exit 1
esac



#for subjNum in $(seq 1 20)
#do

	subjIndx=$((${subjNum} - 1)) #corresponding number
	echo ${subjNum}

	subjFolder=${subjects[${subjIndx}]} #subj to organize

	printf -v subjS "%03d" ${subjNum} #creates the padded number of the subj 
	nFiles=${#fileList[@]} #gets the number of files in the folder
	task=001 #number of task (this is arbitrary), most of the times it is 001, it could change if in the same experiment the subj underwent different scans of completely different paradigms (not repetitions)
	echo creating ${subjFolder} directories
	mkdir ${dataFolder}/data/sub${subjS} -p -v #creates the directory for the subj
	mkdir ${dataFolder}/data/sub${subjS}/masks -p -v #creates the folder for the masks and A0
	mkdir ${dataFolder}/data/sub${subjS}/masks/orig -p -v #creates the folder for the masks and A0
	echo getting A0
	fslroi ${inputFolder}/${subjFolder}_${fileList[0]} ${dataFolder}/data/sub${subjS}/masks/A0.nii.gz 0 1 #gets the first volume of the first scan
	cp ${inputFolder}/${subjFolder}_Anatomic.nii.gz ${dataFolder}/data/sub${subjS}/masks/Anatomic.nii.gz
	echo ${subjFolder}
	for i in $(seq 1 ${nFiles})
	do
		printf -v runS "%03d" ${i} #creates the padded number of run
		echo creating directory fOr run...
		inputFile=${inputFolder}/${subjFolder}_run${i}.nii.gz
		outFolder=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${runS}
		mkdir ${outFolder} -p -v
		cp ${inputFile} ${outFolder}/uncorrected.nii.gz #creates a copy of the file in the corresponding folder
		mcflirt -in ${outFolder}/uncorrected.nii.gz -r ${dataFolder}/data/sub${subjS}/masks/A0.nii.gz -out ${outFolder}/BOLD.nii.gz -report -plots
		#cp ${outFolder}/BOLD.nii.gz.par /media/sf_Google_Drive/Results/SST/movement/dog${subjS}_run${i}.par
		#cp ${outFolder}/BOLD.nii.gz.par ${inputFolder}/movement/${subjS}_run${i}.par
		mkdir /media/sf_Google_Drive/Results/${projectName}/movement -p -v
		cp ${outFolder}/BOLD.nii.gz.par /media/sf_Google_Drive/Results/${projectName}/movement/${project}${subjS}_run${i}.par
#MOVEMENT CORRECTION PLOT
		fsl_tsplot -i ${outFolder}/BOLD.nii.gz.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 640 -h 144 -o ${inputFolder}/movement/${subjFolder}_run${i}_rot.png 
		fsl_tsplot -i ${outFolder}/BOLD.nii.gz.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 640 -h 144 -o ${inputFolder}/movement/${subjFolder}_run${i}_trans.png
		

		rm ${outFolder}/uncorrected.nii.gz
		fslmaths ${outFolder}/BOLD.nii.gz -Tmean ${outFolder}/m_BOLD.nii.gz
	done


	echo getting the mean img...	
	names=""
	for fileNum in $(seq -f "%03g" 1 ${nFiles})
	do
		file=${dataFolder}/data/sub${subjS}/BOLD/task${task}_run${fileNum}/m_BOLD.nii.gz
		names+=${file}" "
	done

	fslmerge -t ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${names}
	fslmaths ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz -Tmean ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz
	cp ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${inputFolder}/meanfct_${subjFolder}.nii.gz
	
#done
#cp ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz ${dataFolder}/data/sub${subjS}/masks/meanfct.nii.gz

#rm ${dataFolder}/data/sub${subjS}/masks/m_BOLD.nii.gz

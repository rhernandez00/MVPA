# ! /bin/bash

proyect=$1
fileSuf=
fileExt=.nii.gz
case "${proyect}" in
	ProsodyFSL)
		echo ProsodyFSL
		folder=/media/sf_data/ProsodyRawFSL/FMApplied
		folderOut=/media/sf_data/ProsodyRawFSL/Reoriented
		declare -a fileNames=("run1" "run2" "run3" "run4")
		dimorder=prosody
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		folder=/media/sf_data/Prosody/Raw
		folderOut=/media/sf_data/Prosody/Raw/ReorientedNoFM
		declare -a fileNames=("Run1" "Run2" "Run3" "Run4")
		fileSuf=_Raw.feat/filtered_func_data.nii.gz
		fileExt=
		dimorder=prosody
		;;
	Prosody)
		echo Prosody
		folder=/media/sf_data/ProsodyRaw/FMApplied
		folderOut=/media/sf_data/ProsodyRaw/Reoriented
		declare -a fileNames=("run1" "run2" "run3" "run4")
		dimorder=prosody
		;;

	Diana)
		echo Diana
		folder=/media/sf_data/DianaRaw/FMApplied
		folderOut=/media/sf_data/DianaRaw/Reoriented
		declare -a fileNames=("run1" "run2")
		dimorder=prosody
		;;
	Diana2)
		echo Diana2
		folder=/media/sf_data/Diana2Raw/FMApplied
		folderOut=/media/sf_data/Diana2Raw/Reoriented
		declare -a fileNames=("run1" "run2")
		dimorder=prosody
		;;
	SST)
		echo SST
		folder=/media/sf_data/SST/Raw
		folderOut=${folder}/Reoriented
		fileSuf=_Raw.feat/filtered_func_data.nii.gz
		fileExt=
		declare -a fileNames=("rs_A" "rs_B")
		dimorder=SST
		#declare -a subjects=("akira" "apacs" "barack" "barney" "bingo" "bodza" "bran" "floyd" "grog" "kamilla" "kefir" "kope" "maverick" "maya" "nia" "sander" "walter" "dome" "luna" "molly")
		declare -a subjects=("luna")
		;;
	SSTMean)
		echo SSTMean
		folder=/media/sf_data/SST/meanToReorient
		folderOut=${folder}/Reoriented
		fileExt=.nii.gz
		declare -a fileNames=("A" "B")
		dimorder=SST
		declare -a subjects=("Dome" "Luna" "Molly")
		;;
	JoeyProsodyNoFM)
		echo JoeyProsody
		folder=/media/sf_data/Prosody/Raw
		folderOut=/media/sf_data/Prosody/Raw/ReorientedNoFM
		fileSuf=_Raw.feat/filtered_func_data.nii.gz
		declare -a fileNames=("Run2")
		fileExt=
		dimorder=Joey
		;;
	*)
		echo Wrong proyect
		exit 1
esac


#dog=$2



#mkdir ${folderOut}
for dog in "${subjects[@]}"
do
	for fileName in "${fileNames[@]}"
	do
		echo ${folder}/${dog}_${fileName}${fileExt}${fileSuf}
		cp ${folder}/${dog}_${fileName}${fileExt}${fileSuf} ${folderOut}/${dog}_${fileName}.nii.gz
		fslorient -deleteorient ${folderOut}/${dog}_${fileName}
		echo swapdim
	#	fslswapdim ${folderOut}/${dog}_${fileName} x -z y ${folderOut}/${dog}_${fileName}
	#	fslswapdim ${folderOut}/${dog}_${fileName} -x z y ${folderOut}/${dog}_${fileName} #maya
		case "${dimorder}" in
			prosody)
			echo arrangment as prosody
			fslswapdim ${folderOut}/${dog}_${fileName}${fileExt} -x z -y ${folderOut}/${dog}_${fileName}${fileExt} #Prosody
			;;
			Joey)
			echo arrangment fo.r Joey, prosody
			fslswapdim ${folderOut}/${dog}_${fileName}${fileExt} z -y -x ${folderOut}/${dog}_${fileName}${fileExt} #Prosody
			;;
			SST)
			echo arrangment as SST, changing name
				case "${fileName}" in 
					rs_A)
						mv ${folderOut}/${dog}_${fileName}.nii.gz ${folderOut}/${dog}_run1.nii.gz
						fileName=run1
						echo run1
						;;
					rs_B)
						mv ${folderOut}/${dog}_${fileName}.nii.gz ${folderOut}/${dog}_run2.nii.gz
						fileName=run2
						echo run2
						;;
				esac
			fslswapdim ${folderOut}/${dog}_${fileName}${fileExt} x y z ${folderOut}/${dog}_${fileName}${fileExt}
			;;
		esac
	
		#fslswapdim ${folder}b/${fileName} x -z y ${folder}b/${fileName}
		#fslswapdim ${folder}b/${fileName} -x y -z ${folder}b/${fileName}
	#	fslswapdim ${folder}b/${fileName} x y z ${folder}b/${fileName}
		echo orient
		fslorient -setsformcode 1 -setqformcode 1 ${folderOut}/${dog}_${fileName}${fileExt}
	done
done

#!/bin/bash

#change the type of .fsf


project=$1
specie=$2

runComplete=true
smoothVar=5.0 #it has always been 5.0



#models refers to both, input model to FSL and output model in the FSL results folder
case "${project}" in
	3cond)
		mvpaDataFolder=/media/sf_data/Complex/Complex${specie}STD/data
		fsloutput=/media/sf_data/Complex/FSLComplex${specie}STD
		fslDesign=03cond
		declare -a models=("005")
		contrastN=3 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=1 #overwritten by a variable below
		;;
	4cond)
		mvpaDataFolder=/media/sf_data/Complex/Complex${specie}STD/data
		fsloutput=/media/sf_data/Complex/FSLComplex${specie}STD
		fslDesign=04condContrast
		declare -a models=("001")
		contrastN=4 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=1 #overwritten by a variable below
		;;
	Faces)
		mvpaDataFolder=/media/sf_data/Faces/Faces${specie}STD/data
		fsloutput=/media/sf_data/Faces/FSLFaces${specie}STD
		fslDesign=04condContrast
		declare -a models=("001")
		contrastN=4 #number of contrasts (categories)
		resPrefix=cope #can take cope, tstat, zstat
		nRuns=6 #overwritten by a variable below
		;;
	4condEV)
		mvpaDataFolder=/media/sf_data/Prosody/NoFMSTD/data
		fsloutput=/media/sf_data/Prosody/FSLNoFMSTD/Prosody
		fslDesign=04condEV
		declare -a models=("051")
		contrastN=4 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4 #overwritten by a variable below
		;;
	2condEV)
		mvpaDataFolder=/media/sf_data/Prosody/NoFMSTD/data
		fsloutput=/media/sf_data/Prosody/FSLNoFMSTD/Prosody
		fslDesign=02condEV
		declare -a models=("052" "053") #models 2 and 15 respectively
		contrastN=2 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4 #overwritten by a variable below
		;;
	16cond)
		mvpaDataFolder=/media/sf_data/Complex/Complex${specie}STD/data
		fsloutput=/media/sf_data/Complex/FSLComplex${specie}STD
		fslDesign=16cond
		declare -a models=("002")
		contrastN=16 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=6 #overwritten by a variable below
		;;
	12condProsody)
		mvpaDataFolder=/media/sf_data/Prosody/NoFMSTD/data
		fsloutput=/media/sf_data/Prosody/FSLNoFMSTD/Prosody
		fslDesign=12cond
		declare -a models=("018")
		contrastN=12 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4 #overwritten by a variable below
		;;
	24condProsody)
		mvpaDataFolder=/media/sf_data/Prosody/NoFMSTD/data
		fsloutput=/media/sf_data/Prosody/FSLNoFMSTD/Prosody
		fslDesign=24cond
		declare -a models=("016")
		contrastN=24 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4 #overwritten by a variable below
		;;
	Complex48)
		mvpaDataFolder=/media/sf_data/Complex/Complex${specie}STD/data
		fsloutput=/media/sf_data/Complex/FSLComplex${specie}STD
		fslDesign=48cond
		declare -a models=("003")
		contrastN=48 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=6 #overwritten by a variable below
		;;
	Complex36)
		mvpaDataFolder=/media/sf_data/Complex/Complex${specie}STD/data
		fsloutput=/media/sf_data/Complex/FSLComplex${specie}STD
		fslDesign=36cond
		declare -a models=("004")
		contrastN=36 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=6 #overwritten by a variable below
		;;
	CEVA1)
		mvpaDataFolder=/media/sf_data/CEVA/CEVASTD/data
		fsloutput=/media/sf_data/CEVA/FSLCEVASTD
		fslDesign=2condContrast
		declare -a models=("001" "002")
		contrastN=2 #number of contrasts (categories)
		resPrefix=cope #can take cope, tstat, zstat
		nRuns=1 #overwritten by a variable below
		;;
	CEVA3)
		mvpaDataFolder=/media/sf_data/CEVA/CEVASTD/data
		fsloutput=/media/sf_data/CEVA/FSLCEVASTD
		fslDesign=18cond
		declare -a models=("003")
		contrastN=18 #number of contrasts (categories)
		resPrefix=cope #can take cope, tstat, zstat
		nRuns=1 #overwritten by a variable below
		;;
	*)
		echo Wrong proyect
		exit 1
esac

case "${specie}" in
	D)
		atlas=/media/sf_Google_Drive/Faces_Hu/CommonFiles/BarneyBrain2mm
		;;
	H)
		atlas=/media/sf_Google_Drive/Faces_Hu/CommonFiles/MNI152_T1_2mm_brain
		;;
	*)
		echo Wrong specie, accepted are D and H
		exit 1
esac


runs=()
for ((i=1;i<nRuns+1;i++)); do
	printf -v j "%03d\n" $i
	runs+=(run${j})
done


#declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010" "sub011" "sub012" "sub014" "sub015" "sub016" "sub017" "sub018")
declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010" "sub011" "sub012")
#declare -a subjects=("sub011" "sub012" "sub013" "sub014" "sub015" "sub016" "sub017" "sub018")
#declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010")
declare -a subjects=("sub011" "sub012" "sub013" "sub014" "sub015" "sub016" "sub017" "sub018" "sub019" "sub020" "sub021" "sub022")
declare -a subjects=("sub023" "sub024" "sub025" "sub026" "sub027" "sub028" "sub029" "sub030" "sub031" "sub032")


declare -a tasks=("001")

runs=("run001" "run002" "run003" "run004" "run005" "run006")
#runs=("run006")

resFiles=()
for ((i=1;i<contrastN+1;i++)); do
	resFiles+=(${resPrefix}${i})
done

for task in "${tasks[@]}"; do
	for model in "${models[@]}"; do
		for subj in "${subjects[@]}"; do
			for run in "${runs[@]}"; do
				echo ${run}
				analyzedFile=${mvpaDataFolder}/${subj}/BOLD/task001_${run}/BOLD			 
				volumes=$(getText.sh ${analyzedFile} vol)
				TR=$(getText.sh ${analyzedFile} TR)
				TR=3.2
				echo ${TR}
				echo ${volumes}
				echo changing .fsf
				echo ${mvpaDataFolder}
				sed -e "s@SMOOTHVAR@${smoothVar}@g;s@ATLASNII@${atlas}@g;s@task00Z@task${task}@g;s@VOLUMESVAR@${volumes}@g;s@TRVAR@${TR}@g;s@MVPADATAFOLDER@${mvpaDataFolder}@g;s@00Y@${model}@g;s@FSLOUTPUT@${fsloutput}@g;s@sub00X@${subj}@g;s@run00X@${run}@g;s@taskXX@task${model}@g;s@modelXX@${model}@g" /home/brain/Desktop/FSL/${fslDesign}.fsf > /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${subj}.fsf
				
				echo running exp:${experiment} model:${model} subj:${subj} run:${run} task:${task}
				if [ ${runComplete} = true ] ; then
					echo running fsl
					feat /home/brain/Desktop/FSL/designTmp${fslDesign}${specie}${subj}.fsf
				fi
				wait

				names=""
				for file in "${resFiles[@]}"; do
					names+=${fsloutput}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/${file}" "
				done

				echo merging...
				fslmerge -t ${fsloutput}/${model}/data/${subj}/BOLD/task001_${run}/BOLD.nii.gz ${names}
				

				#####SHOULD UNCOMMENT
				if [ ${runComplete} = true ] ; then
					echo deleting...
					rm ${fsloutput}/${model}/data/${subj}/BOLD/task001_${run}/.feat/filtered_func_data.nii.gz
					rm ${fsloutput}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/res4d.nii.gz
					rm ${fsloutput}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/threshac1.nii.gz
				fi
			
			done
		done
	done
done

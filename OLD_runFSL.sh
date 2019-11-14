#!/bin/bash

#change the type of .fsf


proyect=$1
#subjNum=$2
case "${proyect}" in
	Objetos)
		experiment=objetos
		fslDesign=objetos
		contrastN=27 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=12
		runComplete=true
		echo objetos
		;;
	ProsodyNoFM)
		echo ProsodyNoFM
		dataFolder=/media/sf_data/Prosody/FSLNoFMSTD
		saveFolder=/media/sf_data/Prosody/FSLNoFMSTD
		experiment=Prosody
		fslDesign=Prosody
		contrastN=5 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4
		runComplete=true
		;;
	ProsodyNoFMImplicit)
		echo ProsodyNoFMImplicitBaseline
		dataFolder=/media/sf_data/Prosody/FSLNoFMSTD
		saveFolder=/media/sf_data/Prosody/FSLNoFMSTD
		experiment=Prosody
		fslDesign=ProsodyImplicitBaseline
		contrastN=4 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4
		runComplete=true
		;;
	ProsodyComplete)
		echo ProsodyNoFMImplicitBaseline
		dataFolder=/media/sf_data/Prosody/FSLNoFMSTD
		saveFolder=/media/sf_data/Prosody/FSLNoFMSTD
		experiment=Prosody
		fslDesign=ProsodyComplete
		contrastN=4 #number of contrasts (categories)
		resPrefix=cope #can take cope, tstat, zstat
		nRuns=4
		runComplete=false
		#use model 43,46
		;;
	Prosody2Cond)
		echo ProsodyNoFMImplicitBaseline
		dataFolder=/media/sf_data/Prosody/FSLNoFMSTD
		saveFolder=/media/sf_data/Prosody/FSLNoFMSTD
		experiment=Prosody
		fslDesign=Prosody2Cond
		contrastN=2 #number of contrasts (categories)
		resPrefix=zstat #can take cope, tstat, zstat
		nRuns=4
		runComplete=true
		#use model 44 and 45, ?probably for models 2 and 15?
		;;
	*)
		echo Wrong proyect
		exit 1
esac



runs=()
for ((i=1;i<nRuns+1;i++)); do
	printf -v j "%03d\n" $i
	runs+=(run${j})
done

#declare -a subjects=("sub005" "sub006" "sub007" "sub008" "sub009" "sub010")
declare -a subjects=("sub001" "sub002" "sub003" "sub004" "sub005" "sub006" "sub007" "sub008" "sub009" "sub010" "sub011" "sub012" "sub013" "sub014" "sub015" "sub016" "sub017" "sub018")
#declare -a subjects=("sub013")

#printf -v subjS "%03d" ${subjNum}
#subj=sub${subjS}
declare -a models=("046")
#declare -a models=("002" "003")
#declare -a tasks=("001")
declare -a tasks=("001")
runs=("run001" "run002" "run003" "run004")


resFiles=()
for ((i=1;i<contrastN+1;i++)); do
	resFiles+=(${resPrefix}${i})
done

for task in "${tasks[@]}"; do
	for model in "${models[@]}"; do
		for subj in "${subjects[@]}"; do
			for run in "${runs[@]}"; do
				echo ${run} 
				sed -e "s/task00Z/task${task}/g;s/00Y/${model}/g;s/experiment/${experiment}/g;s/sub00X/${subj}/g;s/run00X/${run}/g;s/taskXX/task${model}/g;s/modelXX/${model}/g" /home/brain/Desktop/FSL/${fslDesign}.fsf > /home/brain/Desktop/FSL/designTmp.fsf
				echo running exp:${experiment} model:${model} subj:${subj} run:${run} task:${task}
				if [ ${runComplete} = true ] ; then
					echo running fsl
					feat /home/brain/Desktop/FSL/designTmp.fsf
				fi
				wait

				names=""
				for file in "${resFiles[@]}"; do
					#names+=/media/sf_usr/share/fsloutput/${experiment}/${model}/data/${subj}/BOLD/task${task}_${run}/.feat/stats/${file}" "
					names+=${dataFolder}/${experiment}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/${file}" "
				done

				echo merging...
				#fslmerge -t /media/sf_usr/share/fsloutput/${experiment}/${model}/data/${subj}/BOLD/task${task}_${run}/BOLD.nii.gz ${names}
				fslmerge -t ${dataFolder}/${experiment}/${model}/data/${subj}/BOLD/task001_${run}/BOLD.nii.gz ${names}
				


				#####SHOULD UNCOMMENT
				if [ ${runComplete} = true ] ; then
					echo deleting...
					#rm /media/sf_usr/share/fsloutput/${experiment}/${model}/data/${subj}/BOLD/task${task}_${run}/.feat/filtered_func_data.nii.gz
					#rm /media/sf_usr/share/fsloutput/${experiment}/${model}/data/${subj}/BOLD/task${task}_${run}/.feat/stats/res4d.nii.gz
					#rm /media/sf_usr/share/fsloutput/${experiment}/${model}/data/${subj}/BOLD/task${task}_${run}/.feat/stats/threshac1.nii.gz
					rm ${dataFolder}/${experiment}/${model}/data/${subj}/BOLD/task001_${run}/.feat/filtered_func_data.nii.gz
					rm ${dataFolder}/${experiment}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/res4d.nii.gz
					rm ${dataFolder}/${experiment}/${model}/data/${subj}/BOLD/task001_${run}/.feat/stats/threshac1.nii.gz
				fi
			
			done
		done
	done
done

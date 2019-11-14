#!/bin/bash

#change the type of .fsf


proyect=$1
#subjNum=$2
case "${proyect}" in
	ProsodyNoFMNoS)
		echo ProsodyNoFMNoS
		declare -a subjects=("Odin" "Maya" "Kunkun" "Bran" "Bingo" "Alma" "Bodza" "Sander" "Akira" "Barack" "Grog" "Maverick" "Monty" "Pan" "Barney" "Dome" "Joey" "Mini") #for Bran I used
		declare -a runs=("1" "2")
		experiment=ProsodyNS
		;;
	*)
		echo Wrong proyect
		exit 1
esac


for subj in "${subjects[@]}"; do
	for run in "${runs[@]}"; do
		echo ${run} 
		sed -e "s/dogXXX/${subj}/g" /home/brain/Desktop/FSL/${experiment}.fsf > /home/brain/Desktop/FSL/designTmp.fsf
		echo running exp:${experiment} subj:${subj} 
		
		echo running fsl
		#feat /home/brain/Desktop/FSL/designTmp.fsf
		wait
	done
done


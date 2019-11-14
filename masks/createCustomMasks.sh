# ! /bin/bash
: '
maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels/
declare -a sides=("L" "R")
cd ${maskFolder}
for side in "${sides[@]}"
do
echo ${side}
fslmaths ${side}_gEctosylviusCaudalis.nii.gz -add ${side}_gSylviusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gEctosylviusMedius.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gSuprasylviusMedius.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gSuprasylviusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gCompositusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal -bin ${side}_Temporal.nii.gz
done
' 
maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels2mm/
echo subcortical dogs
declare -a subjs=(sub001 sub002 sub003)

case "${proyect}" in
	ProsodyFSL)
		echo ProsodyFSL
		folder=/media/sf_data/ProsodyRawFSL/FMApplied
		folderOut=/media/sf_data/ProsodyRawFSL/Reoriented
		declare -a fileNames=("run1" "run2" "run3" "run4")
		dimorder=prosody
		;;
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
declare -a maskList=("gEctosylviusCaudalis" "gEctosylviusMedius" "gEctosylviusRostralis")
declare -a maskList=("gSuprasylviusCaudalis" "gSuprasylviusMedius" "gSuprasylviusRostralis")
declare -a maskList=("gSylviusCaudalis" "gSylviusRostralis")

cd ${maskFolder}/subcortical
fslmaths b_Diencephalon.nii.gz -add b_Mesencephalon.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_Pons.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_VermisCerebelli.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add L_aSubcallosa.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add R_aSubcallosa.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add L_Thalamus.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add R_Thalamus.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_encephalon.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_MedullaOblongata.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_MedullaSpinalis.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add R_HemispheriumCerebelli.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add L_HemispheriumCerebelli.nii.gz b_Subcortical.nii.gz

fslmaths b_Subcortical.nii.gz -add L_hippocampus.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add R_hippocampus.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add L_gParahippocampalis.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add R_gParahippocampalis.nii.gz b_Subcortical.nii.gz

fslmaths b_Subcortical.nii.gz -add R_bOlfactorius.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add L_bOlfactorius.nii.gz b_Subcortical.nii.gz

fslmaths b_Subcortical.nii.gz -bin b_Subcortical.nii.gz
fslmaths BarneyBrain_extracted -bin brain.nii.gz

#fslmaths b_Subcortical.nii.gz -bin b_Subcortical.nii.gz
#cp b_Subcortical.nii.gz ${maskFolder}
fslmaths b_Subcortical.nii.gz -binv b_Subcortical2.nii.gz
fslmaths b_Subcortical2.nii.gz -mul brain.nii.gz b_Cortex.nii.gz
cp b_Cortex.nii.gz ${maskFolder}

#fslmaths ${maskFolder}/b_fullBrain.nii.gz -sub b_Subcortical.nii.gz b_Cortex
#fslmaths b_Cortex -thr 1 -bin b_Cortex.nii.gz
#fslmaths brain -mul b_Cortex.nii.gz b_Cortex.nii.gz
#fslmaths b_Cortex.nii.gz -bin b_Cortex.nii.gz
#cp b_Cortex.nii.gz ${maskFolder}

echo subcortical humans
maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Harvard
cd ${maskFolder}/subcortical
fslmaths L_CerebralCortex -thr 10 -bin L_CerebralCortexB.nii.gz 
fslmaths R_CerebralCortex -thr 10 -bin R_CerebralCortexB.nii.gz
fslmaths R_CerebralCortex -add L_CerebralCortex b_CerebralCortex.nii.gz
fslmaths b_CerebralCortex.nii.gz -bin b_CerebralCortex.nii.gz
fslmaths ${maskFolder}/b_fullBrain.nii.gz -sub b_CerebralCortex.nii.gz b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -thr 1 -bin b_Subcortical.nii.gz
fslmaths b_Subcortical.nii.gz -add b_Cerebellum b_Subcortical
fslmaths b_Subcortical.nii.gz -thr 1 -binv b_Subcortical2.nii.gz

fslmaths ${maskFolder}/b_fullBrain.nii.gz -mul b_Subcortical2.nii.gz b_Cortex
fslmaths b_Cortex -thr 1 -bin b_Cortex.nii.gz


#fslmaths b_Cerebellum.nii.gz -add L_CerebralCortexB.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add R_CerebralCortexB b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -bin b_Subcortical.nii.gz
#cp b_Subcortical.nii.gz ${maskFolder}


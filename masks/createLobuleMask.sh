# ! /bin/bash

maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels/
declare -a sides=("L" "R")
cd ${maskFolder}
for side in "${sides[@]}"
do
fslmaths ${side}_gEctosylviusCaudalis.nii.gz -add ${side}_gSylviusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gEctosylviusMedius.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gSuprasylviusMedius.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gSuprasylviusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal.nii.gz -add ${side}_gCompositusCaudalis.nii.gz ${side}_Temporal.nii.gz
fslmaths ${side}_Temporal -bin ${side}_Temporal.nii.gz
done
 


#cd ${maskFolder}/subcortical
#do
#fslmaths b_Diencephalon.nii.gz -add b_Mesencephalon.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add b_Pons.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add b_VermisCerebelli.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add L_aSubcallosa.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add R_aSubcallosa.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add L_Thalamus.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -add R_Thalamus.nii.gz b_Subcortical.nii.gz
#fslmaths b_Subcortical.nii.gz -bin b_Subcortical.nii.gz
#done

for side in "${sides[@]}"
do
fslmaths ${side}_Temporal.nii.gz -add ${side}_gEctomarginalis.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_gOccipitalis.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_gParahippocampalis.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_hippocampus.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_lPiriformis.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_Amygdala.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal.nii.gz -add ${side}_gMarginalis.nii.gz ${side}_OccipitoTemporal.nii.gz
fslmaths ${side}_OccipitoTemporal -bin ${side}_OccipitoTemporal.nii.gz
done

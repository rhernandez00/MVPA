# ! /bin/bash

maskFolder=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels
maskFolder2mm=/media/sf_Google_Drive/Faces_Hu/CommonFiles/Dogs/Labels2mm

declare -a maskList=("gEctosylviusCaudalis" "gEctosylviusMedius" "gEctosylviusRostralis" "gSuprasylviusCaudalis" "gSuprasylviusMedius" "gSuprasylviusRostralis" "gSylviusCaudalis" "gSylviusRostralis")


declare -a sides=("L_" "R_")


for side in "${sides[@]}"; do 
	fslmaths ${maskFolder}/${side}gSylviusCaudalis.nii.gz -add ${maskFolder}/${side}gSylviusRostralis.nii.gz ${maskFolder}/${side}gSylvius

	fslmaths ${maskFolder}/${side}gSuprasylviusRostralis.nii.gz -add ${maskFolder}/${side}gSuprasylviusCaudalis.nii.gz ${maskFolder}/${side}gSuprasylvius
	fslmaths ${maskFolder}/${side}gSuprasylvius -add ${maskFolder}/${side}gSuprasylviusMedius ${maskFolder}/${side}gSuprasylvius

	fslmaths ${maskFolder}/${side}gEctosylviusCaudalis -add ${maskFolder}/${side}gEctosylviusMedius ${maskFolder}/${side}gEctosylvius
	fslmaths ${maskFolder}/${side}gEctosylvius -add ${maskFolder}/${side}gEctosylviusRostralis ${maskFolder}/${side}gEctosylvius


	fslmaths ${maskFolder}/${side}gEctosylvius -add ${maskFolder}/${side}gSylvius ${maskFolder}/${side}gPerisylvius

	fslmaths ${maskFolder}/${side}gPerisylvius -add ${maskFolder}/${side}gSuprasylviusMedius ${maskFolder}/${side}gPerisylvius

	fslmaths ${maskFolder}/${side}gPerisylvius -bin ${maskFolder}/${side}gPerisylvius
	flirt -in ${maskFolder}/${side}gPerisylvius -ref ${maskFolder}/${side}gPerisylvius -out ${maskFolder2mm}/${side}gPerisylvius -applyisoxfm 2
	fslmaths ${maskFolder2mm}/${side}gPerisylvius -bin ${maskFolder2mm}/${side}gPerisylvius
done

fslmaths ${maskFolder}/L_gPerisylvius -add ${maskFolder}/R_gPerisylvius ${maskFolder}/b_gPerisylvius
fslmaths ${maskFolder2mm}/L_gPerisylvius -add ${maskFolder2mm}/R_gPerisylvius ${maskFolder2mm}/b_gPerisylvius

fslmaths ${maskFolder2mm}/b_gPerisylvius -bin ${maskFolder2mm}/b_gPerisylvius

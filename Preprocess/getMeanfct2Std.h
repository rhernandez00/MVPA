
proyect=$1

case "${proyect}" in
	Prosody)
		echo Prosody
		inputFolder=/media/sf_data/ProsodyRawFSL/Reoriented
		dataFolder=/media/sf_data/ProsodyFSL
		declare -a subjects=("Odin" "Maya" "Kunkun" "Bran" "Bingo" "Alma" "Bodza" "Sander" "Akira" "Barack" "Grog" "Maverick" "Monty" "Pan") #for Bran I used
		;;
	*)
		echo Wrong proyect
		exit 1
esac


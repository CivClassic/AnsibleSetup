function showCivUtilsHelp() {
	echo "Invocations of this script must provide an action to execute and a set of parameters"
	echo ""
	echo "extractlocalbackup           # Will extract the region file of the given coordinates from the last backup and put it around 100k, 100k in the live setup. Expects at least two arguments, the x and z coordinate of the location to extract (location coords, not region file or chunk coords) and optionally how many backups to go back (by default 1, meaning the latest)"
}

if test "$#" -lt 1; then
	echo "You need to provide an action"
	showCivUtilsHelp
	exit 1
fi

argument="$1"

#Force into lower case
case "${argument,,}" in
	extractlocalbackup)
		if [ "$#" -lt 3 ]; then
    		echo "You need to specify x and z coordinates of the location to extract"
    		exit 1
		fi
		regionX=$(( "$2" >> 9 ))
		regionZ=$(( "$3" >> 9 ))
		echo "Attemption extraction of single region file $regionX $regionZ from backup"
		startRegion100=99840
		xOffset=$(( "$2" & 511 ))
		xOffset=$(( "$xOffset" + startRegion100 )) 
		zOffset=$(( "$3" & 511 )) 
		zOffset=$(( "$zOffset" + startRegion100 )) 
		echo "Desired location will be at $xOffset , $zOffset"
		backupGoBack=1
		if [ "$#" -gt 3 ]; then
    		backupGoBack="$4"
		fi
		backupGoBack=$(( backupGoBack - 1 )) #Both converts into 0 based indices and ensures it's actually a number
		if [ "$backupGoBack" -lt 0 ]; then
    		echo "Backups to go back must be a positive number"
    		exit 1
		fi
		ansible-playbook server.yml --extra-vars '{"extract_single_region":"true", "backup_go_back_count":"'"$backupGoBack"'", "region_x":"'"$regionX"'", "region_z":"'"$regionZ"'", "region_world":"world", "target_region_x":"195", "target_region_z":"195"}'
		;;
esac
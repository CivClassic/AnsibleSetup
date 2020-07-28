#!/usr/bin/env bash

function showCivAnsibleHelp() {
	echo "Invocations of this script must provide a valid set of actions to complete. Actions will be executed in the order they are provided. Valid actions are:"
	echo ""
	echo "deploy           # Will do an initial deployment of the setup, creating databases, database users, folder structures etc."
	echo "update           # Updates all plugin jars and configurations in the deployed setup"
	echo "pull             # Pulls from the master branch of the git repository configured as origin"
	echo "warn10           # Announces an upcoming restart to the server in 10 minutes in increments and blocks until that time span has elapsed"
	echo "backup           # Creates full backup of the map, plugin configs and mysql database in the deployed setup"
	echo "stopminecraft    # Stops the minecraft server"
	echo "stopbungee       # Stops BungeeCord"
	echo "stop             # Stops the minecraft server and then BungeeCord"
	echo "startminecraft   # Starts the minecraft server"
	echo "startbungee      # Starts BungeeCord"
	echo "start            # Starts BungeeCord and then the minecraft server"
	echo "help             # Shows this list of commands"
}

if test "$#" -lt 1; then
	echo "You need to provide an action"
	showCivAnsibleHelp
	exit 1
fi

#Iterate over all provided arguments
for var in "$@"
do
	#Force into lower case
    case "${var,,}" in
    	deploy)
			echo "Deploying a full server setup including databases"
			if [[ $EUID -ne 0 ]]; then
   				echo "Initial deployment requires root/sudo, please rerun the script as such" 
  				exit 1
			fi
			ansible-playbook server.yml --extra-vars '{"do_deploy":"true"}'
			;;
		update)
			echo "Updating all plugins and configurations"
			ansible-playbook server.yml --extra-vars '{"do_update":"true"}'
			;;
		pull)
			echo "Pulling latest from git"
			#Not using git pull here to handle errors a bit more gracefully
			git fetch origin
			git merge origin/master
			;;
		warn10)
			echo "Announcing a restart in 10 minutes to the server"
			ansible-playbook server.yml --extra-vars '{"do_warn10":"true"}'
			;;
		backup)
			echo "Creating a backup of the current minecraft map, configs and database"
			ansible-playbook server.yml --extra-vars '{"do_backup":"true"}'
			;;
		stopminecraft)
			echo "Stopping Minecraft"
			ansible-playbook server.yml --extra-vars '{"do_stopminecraft":"true"}'
			;;
		stopbungee)
			echo "Stopping Bungee"
			ansible-playbook server.yml --extra-vars '{"do_stopbungee":"true"}'
			;;
		stop)
			echo "Stopping Bungee and Minecraft"
			ansible-playbook server.yml --extra-vars '{"do_stopbungee":"true", "do_stopminecraft":"true"}'
			;;
		startminecraft)
			echo "Starting Minecraft"
			ansible-playbook server.yml --extra-vars '{"do_startminecraft":"true"}'
			;;
		startbungee)
			echo "Starting Bungee"
			ansible-playbook server.yml --extra-vars '{"do_startbungee":"true"}'
			;;
		stop)
			echo "Starting Bungee and Minecraft"
			ansible-playbook server.yml --extra-vars '{"do_startbungee":"true", "do_startminecraft":"true"}'
			;;
		help)
			echo "Printing help:"
			showCivAnsibleHelp
			;;
		*)
			echo -e "\e[31mThe action '$var' could not be recognized, aborting execution\e[0m"
			echo ""
			showCivAnsibleHelp
			exit 1
    esac
done


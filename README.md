# AnsibleSetup
Civclassic 1.16.1 Ansible setup


## How to deploy:

First of all note that Ansible does not support Windows, you will need a UNIX based operating system. Civclassics uses Debian/Ubuntu and all instructions in the following will be based on that. Note that the Windows Subsystem for Linux is NOT a UNIX based operating system, do not report issues when trying to run this setup on it and install a proper OS.


- Install Java (minimum 8)

https://www.java.com/en/download/help/linux_x64_install.xml

- Install Git, Python and MariaDB

`sudo apt-get install git python python3-pip python-dev default-libmysqlclient-dev python3-pymysql mariadb-server mariadb-client byobu curlftpfs dirmngr`

If `python3-mysql` can't be found or you are later on getting an error like ` "The PyMySQL (Python 2.7 and Python 3.X) or MySQL-python (Python 2.X) module is required."` try `sudo apt-get install python-pymysql`

Recommendend optionals for managing a server:

`sudo apt-get install htop iotop`

- Install Ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- Configure a root password for MariaDB

https://www.digitalocean.com/community/tutorials/how-to-reset-your-mysql-or-mariadb-root-password

Note that in the following the terms MariaDB and Mysql are used interchangeably

- Create a user under which the server will be running

By default this user is named mc, so: `sudo adduser mc`
You may use a different user name, if you do so you will need to adjust the user name setting in `variables/all.yml`


- Clone this repo
```
git clone https://github.com/CivClassic/AnsibleSetup.git
cd AnsibleSetup
```

- Create the file variables/passwords.yml and fill it as follows:

```
#Name of the mysql root user
mysql_root_user: root
#Mysql root password
mysql_root_pass: squidlover69
#Password to use for the newly created mysql user
mysql_non_root_pass: squidlover420
#Host of the mysql database
mysql_host: localhost
#Name of the mysql user to use, will be automatically created
mysql_user: '{{ servername }}'
#Name of the database to use
mysql_db_name: 'civclassic'
#Port mysql is using, 3306 by default
mysql_port: 3306
#Seeds used for HiddenOre noise generation
hidden_ore_density_seed: 13
hidden_ore_height_seed: 14
#Seed used for FactoryMod wordbank
wordbank_seed: abcd
#Optional API key to make Bansticks ip hub lookup work
ip_hub_key:
#BungeeGuard Key used to avoid BungeeSpoofing (change this if you don't have a firewall setup properly)
bungee_guard_token: abcdef
#FTP user name to use for mounting backup point
remote_backup_user: squid
#Password to use for mounting FTP backup point
remote_backup_password: ink
#URL to use for FTP backup point
remote_backup_server: some.backup.domain
```

You should only have to change `mysql_root_pass` to your MariaDB root password and change `mysql_non_root_pass` to an arbitrary random string for this to work

- Configure the setup according to your needs

Check out `variables/all.yml` and change values as you see fit. You will most likely need to change `mysql_socket_location` to `/var/run/mysqld/mysqld.sock` and you also most likely want to use less RAM than we do.

- Run the deploy script

`sudo bash server.sh deploy`

This script requires sudo for the initial database setup. You only need to run it as root once at the beginning or if you want to change the database or user name used. Past that any invocations of `server.sh` should not require sudo. `server.sh` is your single access point to controlling your entire setup, run `bash server.sh help` to see a full list of available commands. 

---

For reference, Civclassic has the following cronjobs setup for the user `mc`:

```
44 7 * * * mv /home/mc/restart.log.txt /home/mc/restart.old.log.txt
45 7 * * * cd /home/mc/AnsibleSetup && bash server.sh pull >> /home/mc/restart.log.txt
50 7 * * * cd /home/mc/AnsibleSetup && bash server.sh warn10 stop backup update start >> /home/mc/restart.log.txt
```

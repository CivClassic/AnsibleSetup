# AnsibleSetup
Civclassic 1.14.4 Ansible setup


## How to deploy:

First of all note that Ansible does not support Windows, you will need a UNIX based operating system. Civclassics uses Debian/Ubuntu and all instructions in the following will be based on that.

- Install Java (minimum 8)

https://www.java.com/en/download/help/linux_x64_install.xml

- Install Git, Python and MariaDB

`sudo apt-get install git python python-pip python-dev default-libmysqlclient-dev python-mysqldb mariadb-server mariadb-client byobu`

- Install Ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- Install PyMySQL

`sudo pip install PyMySQL`

- Configure a root password for MariaDB

https://www.digitalocean.com/community/tutorials/how-to-reset-your-mysql-or-mariadb-root-password

Note that in the following the terms MariaDB and Mysql are used interchangeably

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
```

You should only have to change `mysql_root_pass` to your MariaDB root password and change `mysql_non_root_pass` to an arbitrary random string for this to work

- Configure the setup according to your needs

Check out `variables/all.yml` and change values as you see fit. You will most likely need to change `mysql_socket_location` to `/var/run/mysqld/mysql.sock`

- Run the deploy script

`bash deploy.sh`

This script requires sudo for the initial database setup and will thus ask for your sudo password. You only need to run this once at the beginning or if you want to change the database or user name used. Past that you can use `update.sh` to apply changes to configs, plugins etc. only, which does not require sudo.

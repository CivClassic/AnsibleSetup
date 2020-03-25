# AnsibleSetup
Civclassic 1.13 Ansible setup

## How to use:

- Install Java (minimum 8)

https://www.java.com/en/download/help/linux_x64_install.xml

- Install Git, Python and MariaDB

`sudo apt-get install git python python-pip python-dev default-libmysqlclient-dev python-mysqldb mariadb-server mariadb-client`

- Install Ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- Install PyMySQL

`sudo pip install PyMySQL`

- Configure a root password for MariaDB

- Clone this repo
```
git clone https://github.com/CivClassic/AnsibleSetup.git
cd AnsibleSetup
```

- Put the MariaDB root password and a password for a new mysql user account in group_vars/secrets.yml

- Run the deploy script

`bash deploy.sh`

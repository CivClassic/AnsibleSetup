FROM debian:10.7
MAINTAINER maxopoly3@gmail.com 

#Ansible repo
RUN apt-get update
RUN apt-get install -y gnupg
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

RUN apt-get update 
RUN apt-get install -y git python python3-pip python-dev default-libmysqlclient-dev python3-pymysql mariadb-server mariadb-client byobu curlftpfs dirmngr openjdk-11-jdk python-pymysql ansible

RUN adduser mc --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "mc:mc" | chpasswd

USER mc
WORKDIR /home/mc/
RUN git clone --depth 1 https://github.com/CivClassic/AnsibleSetup.git
WORKDIR /home/mc/AnsibleSetup
RUN cp templates/passwords.yml variables/passwords.yml
USER root
RUN bash server.sh deploy
USER mc
RUN bash server.sh update

EXPOSE 25565/tcp

CMD [“echo”,”Completed image creation”] 

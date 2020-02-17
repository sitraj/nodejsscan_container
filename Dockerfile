FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get install -y curl python3-pip sudo wget
# RUN apt-get install -y curl python3-pip openssh-server sudo wget

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
# ENV sudo DEBIAN_FRONTEND=noninteractive

ADD tools/install_tzdata.sh ./
RUN sudo sh ./install_tzdata.sh
RUN sudo pip3 install nodejsscan
RUN sudo mkdir /var/run/sshd
# RUN sudo echo "root:QpAlZm@10293" | chpasswd

# RUN npm install
# ARG DEBIAN_FRONTEND=noninteractive
RUN sudo wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
RUN sudo apt-get install -y gnupg
# RUN sudo wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
# RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
ADD mongodb-org-4.2.list /etc/apt/sources.list.d/mongodb-org-4.2.list 


RUN sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

RUN sudo apt-get -y update
RUN sudo apt-get install -y mongodb-org

# RUN sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
# RUN sudo sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# ENV NOTVISIBLE "in users profile"
# RUN sudo echo "export VISIBLE=now" >> /etc/profile

# RUN ["sudo", "cp", "-r", "test-src", "/opt/test-src/"]
ADD test-src /opt/test-src/
ADD tools/run.sh /opt/run.sh
RUN sudo chown docker:docker /opt/test-src -R
RUN sudo chmod 755 /opt/test-src -R
RUN sudo sh /opt/run.sh
RUN sudo rm -rf /opt/run.sh
ADD ParseScanResult.py /opt/ParseScanResult.py
EXPOSE 22
# CMD ["python3.6", "/opt/ParseScanResult.py"]
# CMD ["/usr/sbin/sshd", "-D"]
# CMD ["/bin/bash", "-i"]

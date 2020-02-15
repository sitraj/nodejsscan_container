FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get install -y curl openssh-server python3-pip
RUN pip3 install nodejsscan
RUN mkdir /var/run/sshd
# RUN echo "root:QpAlZm@10293" | chpasswd

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
# RUN npm install
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN apt-get install -y gnupg
# RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
# RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
ADD mongodb-org-4.2.list /etc/apt/sources.list.d/mongodb-org-4.2.list 

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get install -y mongodb-org

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD test-src /opt/test-src/
ADD tools/run.sh /opt/run.sh
RUN sh /opt/run.sh
RUN rm -rf /opt/run.sh
ADD ParseScanResult.py /opt/ParseScanResult.py
EXPOSE 22
# CMD ["python3.6", "/opt/ParseScanResult.py"]
CMD ["/usr/sbin/sshd", "-D"]

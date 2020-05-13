FROM centos


RUN yum install git -y
RUN yum install sudo -y 

RUN curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo

RUN rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key


RUN yum install java-11-openjdk.x86_64 -y
RUN yum install jenkins -y

RUN yum install yum-utils device-mapper-persistent-data lvm2 -y

RUN yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo

RUN yum -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm


RUN yum install -y docker-ce

CMD /etc/alternatives//java -Dcom.sun.akuma.Daemon=deamonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/jenkins -jar /usr/lib/jenkins/jenkins.war --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --daemon --httpPort=8080 --debug=5 handlerCountMax=100 --handlerCountMaxIdle=20 
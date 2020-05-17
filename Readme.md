
# Jenkins inside Docker that manage All Containers
## Task 2-
1.  Create container image that’s has Jenkins installed using dockerfile
2.  When we launch this image, it should automatically starts Jenkins service in the container.
3.  Create a job chain of  **job1, job2, job3**  and  **job4** using build pipeline plugin in Jenkins
4.  **Job1**  : Pull the Github repo automatically when some developers push repo to Github.
5.  **Job2**  : By looking at the code or program file, Jenkins should automatically start the respective language interpreter install image container to deploy code ( eg. If code is of PHP, then Jenkins should start the container that has PHP already installed ).
6.  **Job3** : Test your app if it is working or not.
7.  **Job4**  : if app is not working , then send email to developer with error messages.
8.  Create One extra job  **job5**  for monitor : If container where app is running. fails due to any reson then this job should automatically start the container again.

## Subtask 1

Our first task was to launch jenkins inside a docker container and launch it.
So we write a docker file to do so as given below

> FROM centos
RUN yum install git -y
RUN yum install sudo -y 
RUN curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo
RUN rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum install java-11-openjdk.x86_64 -y
RUN yum install jenkins -y
CMD systemctl start jenkins

But As we know Docker conatiner does not support systemctl command we want something that will run jenkins 
so i tried multiple things and came up with as solution 
>CMD /etc/alternatives//java -Dcom.sun.akuma.Daemon=deamonized -Djava.awt.headless=true -DJENKINS_HOME=/var/lib/jenkins -jar /usr/lib/jenkins/jenkins.war --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war --daemon --httpPort=8080 --debug=5 handlerCountMax=100 --handlerCountMaxIdle=20 

To build this docker file we used 
> docker build --tag jenkins-nhm .

## Subtask 2
Our next task is to run docker conatiner from this jenkins container
to do so we want to install docker inside this conatiner, so we have to change our docker file once again
>FROM centos
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

this leads us to install docker inside the jenkins container
Build Command-
> docker build --tag jenkins-nhm .

## Run the above created image
Now since we created our image, its time to run the conatiner.
to do so we have to do following things

 1. Expose jenkins port to out world
 2. Expose some more ports that may be required later
 3. Conatiner name
 4. Image name

But here is the main problem arise, since we need a default pass word to open jenkins first time, but we can't access the jenkins container as jenkins running in the conatainer and making it in backgroud our container stops, 
some I come come with solution to merge Host OS jenkinks password with this Jenkins container 

 5. Use -v to link both jenkins password folder

Same thing i did for Docker

 6. use -v to link both docker files
 

Final Run command as follows- 
> docker run --network bridge -p 8082:8080 -p 8083:8083 -p 8084:8084 -p 8085:8085 -p 8086:8086 -v /var/lib/jenkins/secrets/initialAdminPassword:/var/lib/jenkins/secrets/initialAdminPassword -v /var/run/docker.sock:/var/run/docker.sock -v /root/devops/hw2/:/var/www/html/ --name jenDockImg jenkins-nhm

 

## Setup Jenkins for First time
Now when you got to brower and access the 8082 port number 
this will run jenkins. which will ask the initial password.

![jenkins](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/1.jpeg)

To find this open Host OS and type
> cat /var/lib/jenkins/secrets/initialAdminPassword

Copy this password and paste it in the password field.

Now change the password and enjoy using it.

## Subtask 3

Now We have to create Job1,2,3,4,5
## Job1

this job will download the code and copy it to the folder that is conected to the container
![job1-1](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job1.PNG)
![job1-2](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job1-2.PNG)

## Job2
This job will run the main server
![job2](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job2-1.PNG)

## Job3 and Job4
this is combination of job 3 and job 4
here we will check if the code is working or not if not then it will send a mail to the developer 
![job3](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job3-1.PNG)

Here you need to setup jenkins for SMTP server i used GMAIL server.

![job4](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job3-2.PNG)

## Job5 
this will check if the main container is up or not.
![job5](https://github.com/narayanhari/JenkinsDocker_Task2/blob/master/job4.PNG)





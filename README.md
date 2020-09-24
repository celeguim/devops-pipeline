
# Proposed architecture

![Technical Design](/images/jenkins.svg)


## Create the environment using terraform

## Install AWS client and configure

    $ aws configure
    $ terraform plan
    $ terraform apply

*Terraform will deploy 3 instances*
1. Jenkins Master
2. Staging
3. Production

*It will be installed Jenkins and docker.*
*SSH keys will be exchanged*  

![Instances](/images/screen2.png)

![AWS Instances](/images/screen1.png)

1. Login to Jenkins server http://public_ip:8080

2. Password can be found on Jenkins server:/var/lib/jenkins/secrets/initialAdminPassword

3. Install suggested plugins

4. Create new user

5. Manage Jenkins

6. Manage Nodes and Cloud

7. New Node (staging, permanent)  
Remote root dir: /home/jenkins-staging  
Launch method via SSH  
Host: private_ip  
Credentials: SSH with private key  
ID: jenkins-staging  
Username: jenkins-staging  
Private key: Enter directly (copy/paste /home/jenkins-staging/.ssh/id_rsa from staging server)

8. Install Jenkins Plugin
- Docker
- Docker Pipeline

9. Create credential dockerhub
- Jenkins/Manage Jenkins/Manage Credentials

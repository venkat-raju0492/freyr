Here we are build a simple spring boot Hello world applcation that is deployed as a docker container which has health check configs

Prerequisites
Java 
maven
docker
permission to push docker images to ecr

1. maven build execute the command below
mvn clean package

once the build is successful, check for hello-world-1.0.0.jar file

2. Docker build execute the below command

docker build -t app1 .

check for image created with command "docker images"

3. Docker tag

docker tag app1 <aws account id>.dkr.ecr.<Region>.amazonaws.com/<ecr repo name>:latest

ex: docker tag app1 175119417300.dkr.ecr.us-west-2.amazonaws.com/freyr-aap1:latest

4. Docker login 

aws ecr get-login-password --region <Region> | docker login --username AWS --password-stdin <aws account id>>.dkr.ecr.<Region>.amazonaws.com

ex: aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 175119417300.dkr.ecr.us-west-2.amazonaws.com

4. Docker push 

docker push 175119417300.dkr.ecr.us-west-2.amazonaws.com/freyr-aap1:latest

Validate the image in ecr
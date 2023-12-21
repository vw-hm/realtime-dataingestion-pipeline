# Use these commands to quickly install Kakfa

scp -i cert.pem cert.pem ec2-user@<IP of the bastion host>:/home/ec2-user 
ssh -i cert.pem ec2-user@<IP of the bastion host>
ssh -i cert.pem ec2-user@<IP of the ec2 host in the private subnet>



#Install Java on Private EC2 Instance 
sudo yum install java-1.8.0

#Install wget
sudo yum install wget

#Download Kafka
wget https://archive.apache.org/dist/kafka/3.4.0/kafka_2.12-3.4.0.tgz

#Untar
tar -xvf kafka_2.12-3.4.0.tgz

#Get Bootstrap server info, add the proper arn
aws kafka get-bootstrap-brokers --cluster-arn arn:aws:kafka:eu-west-1:xxxxxxxxxxxxx:cluster/demo-msk/0679c61f-cf0b-4d08-807d-466dc11b9a0c-4
#{
#    "BootstrapBrokerString": "b-2.demomsk.4l5hj9.c4.kafka.eu-west-1.amazonaws.com:9092,b-1.demomsk.4l5hj9.c4.kafka.eu-west-1.amazonaws.com:9092"
#}

#Create topic
bin/kafka-topics.sh --create --topic demo_testing2 --bootstrap-server <Add the bootstrap servers, output of the previous command> --replication-factor 1 --partitions 2

#Create consumer to check if the data is incoming
#Start kafka console consumer and check whether from Lambda messages are getting published in kafka topic or not
bin/kafka-console-consumer.sh --topic demo_testing2 --bootstrap-server <Add the bootstrap servers, output of the previous command>
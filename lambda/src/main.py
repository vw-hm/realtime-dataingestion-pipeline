from json import dumps
from kafka import KafkaProducer
import json
import os

# Retrieve bootstrap servers from environment variables
msk_broker1 = os.environ.get('MSKBroker1')
msk_broker2 = os.environ.get('MSKBroker2')

# Check if both environment variables are present
if not msk_broker1 or not msk_broker2:
    raise ValueError("MSKBroker1 and MSKBroker2 environment variables are required.")

topic_name = 'demo_testing2'
bootstrap_servers = [msk_broker1, msk_broker2]
producer = KafkaProducer(bootstrap_servers=bootstrap_servers, value_serializer=lambda x: dumps(x).encode('utf-8'))

def handle(event, context):
    print(event)
    for i in event['Records']:
        sqs_message = json.loads(i['body'])
        print(sqs_message)
        producer.send(topic_name, value=sqs_message)
    
    producer.flush()

from co import get_co_data
from kafka import KafkaProducer,KafkaConsumer
import six,time,json

topicName = 'codata'
kafka_server = '192.168.1.104:9092'
if True:
    producer = KafkaProducer(bootstrap_servers=kafka_server)
    codataClass = get_co_data()
    codataStream = codataClass.repeat_get_data()
    i = 0
    while i<20*9999999:
        print("now at raspberry pi {}".format(i))
        message = 'raspberry pi some_message_bytes  {}'.format(i)
        codata = next(codataStream)
        codata = json.dumps(codata)
        producer.send(topicName, six.b(codata))
        time.sleep(10)
        i += 1
else:
    consumer = KafkaConsumer(topicName,bootstrap_servers=kafka_server,auto_offset_reset='earliest',group_id=None)
    for msg in consumer:
        print(msg)
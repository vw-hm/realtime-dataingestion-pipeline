"""
import json
import base64
import csv
from io import StringIO

output = []

def convert_to_csv(json_data):
    # Load JSON data
    data = json.loads(json_data)

    # Create a CSV string using StringIO
    csv_buffer = StringIO()
    csv_writer = csv.writer(csv_buffer, quoting=csv.QUOTE_ALL)

    # Write data
    csv_writer.writerow(map(str, data.values()))

    # Get CSV string
    csv_output = csv_buffer.getvalue()

    # Close the buffer
    csv_buffer.close()

    return base64.b64encode(csv_output.encode('utf-8')).decode('utf-8')

def lambda_handler(event, context):
    print(event)
    
    for record in event['records']:
        # Decode and load JSON data from the record
        payload = json.loads(base64.b64decode(record['data']).decode('utf-8'))
        print('payload:', payload)
        
        # Convert JSON to CSV
        output_payload_postprocessed = convert_to_csv(json.dumps(payload))

        # Create the output record
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': output_payload_postprocessed
        }
        output.append(output_record)

    print('Processed {} records.'.format(len(event['records'])))

    return {'records': output}
"""

import json
import base64
import csv
from io import StringIO

output = []

def convert_to_csv(json_data, columns):
    # Load JSON data
    data = json.loads(json_data)

    # Create a CSV string using StringIO
    csv_buffer = StringIO()
    csv_writer = csv.writer(csv_buffer, quoting=csv.QUOTE_ALL)

    # Write specific columns
    csv_writer.writerow([data.get(column, '') for column in columns])

    # Get CSV string
    csv_output = csv_buffer.getvalue()
    print(csv_output)

    # Close the buffer
    csv_buffer.close()

    return base64.b64encode(csv_output.encode('utf-8')).decode('utf-8')

def lambda_handler(event, context):
    print(event)
    
    # Specify the columns you want in the CSV output
    desired_columns = ['_id', 'isActive', 'balance', 'picture', 'age', 'eyeColor', 'name', 'gender',
                        'company', 'email', 'phone', 'address', 'registered', 'latitude', 'longitude',
                          'favoriteFruit']  # Replace with your desired column names
    
    for record in event['records']:
        # Decode and load JSON data from the record
        payload = json.loads(base64.b64decode(record['data']).decode('utf-8'))
        print('payload:', payload)
        
        # Convert JSON to CSV with only specific columns
        output_payload_postprocessed = convert_to_csv(json.dumps(payload), desired_columns)

        # Create the output record
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': output_payload_postprocessed
        }
        output.append(output_record)

    print('Processed {} records.'.format(len(event['records'])))

    return {'records': output}

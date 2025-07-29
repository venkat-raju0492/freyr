import boto3
import json
import os

lambda_client = boto3.client('lambda')

def lambda_handler(event, context):
    print("Lambda 2 received:", event)

    response = lambda_client.invoke(
        FunctionName=os.environ['LAMBDA_3_ARN'],
        InvocationType='RequestResponse',
        Payload=json.dumps({"payload_from_lambda2": event})
    )

    response_payload = json.loads(response['Payload'].read().decode('utf-8'))
    print("Response from Lambda 3:", response_payload)

    return {
        "statusCode": 200,
        "message": "Lambda 2 completed",
        "lambda3_response": response_payload
    }

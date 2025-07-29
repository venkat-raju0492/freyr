import boto3
import json
import os

lambda_client = boto3.client('lambda')

def lambda_handler(event, context):
    print("Lambda 1 received:", event)

    response = lambda_client.invoke(
        FunctionName=os.environ['LAMBDA_2_ARN'],  # You set this as an env var
        InvocationType='RequestResponse',  # Or 'Event' for async
        Payload=json.dumps({"payload_from_lambda1": event})
    )

    # Decode Lambda 2 response
    response_payload = json.loads(response['Payload'].read().decode('utf-8'))
    print("Response from Lambda 2:", response_payload)

    return {
        "statusCode": 200,
        "message": "Lambda 1 completed",
        "lambda2_response": response_payload
    }

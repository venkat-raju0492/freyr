def lambda_handler(event, context):
    print("Lambda 3 received:", event)
    return {
        "statusCode": 200,
        "message": "Lambda 3 processed input",
        "final_output": event
    }

Sample python program to print hello world when ever lambda is invoked

zip the lambda_function.py and upload to s3 to deploy it to lambda function

zip lambda_function.zip lambda_function.py

aws s3 cp lambda_function.zip s3://freyr-terraform-state-files-bucket/app2/lambda-code/lambda_function.zip

Deploy zip file into lamnda function
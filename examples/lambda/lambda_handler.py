import os
import logging
import json

logging.getLogger().setLevel(logging.WARNING)

def lambda_handler(event, context):
    print("I'm running!")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

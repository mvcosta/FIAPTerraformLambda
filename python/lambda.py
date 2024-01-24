import psycopg2
import json
import boto3
import jwt
from datetime import datetime, timedelta

# Use this code snippet in your app.
# If you need more information about configurations
# or implementing the sample code, visit the AWS docs:
# https://aws.amazon.com/developer/language/python/

secret_name = "fiap-db"
region_name = "us-east-1"

# Create a Secrets Manager client
session = boto3.session.Session()
client = session.client(service_name="secretsmanager", region_name=region_name)

get_secret_value_response = client.get_secret_value(SecretId=secret_name)

# Decrypts secret using the associated KMS key.
credential = json.loads(get_secret_value_response["SecretString"])
credential["db"] = "fiapPedido"

connection = psycopg2.connect(
    user=credential["username"],
    password=credential["password"],
    host=credential["host"],
    database=credential["db"],
)


def generate_jwt_token(id=None, name=None, cpf=None):
    issued_at = datetime.utcnow()
    expiration_time = issued_at + timedelta(days=30)

    payload = {
        "sub": id,
        "name": name,
        "cpf": cpf,
        "iat": issued_at.timestamp(),
        "exp": expiration_time.timestamp(),
    }

    secret_key = "5nOMyyNNXhb0dVBWwG6dFCxzIatOBIaWhNELxCfbOkeeiBrElSWXILGDsvHQqlFx"
    algorithm = "HS256"

    token = jwt.encode(payload, secret_key, algorithm=algorithm)
    return token

def generate_response(token):
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({"token": token})
    }

def lambda_handler(event, context):
    body = event.get("body")
    if not body:
        token = generate_jwt_token()
        return generate_response(token)

    try:
        decodedEvent = json.loads(body)
    except:
        decodedEvent = body
    cpf = decodedEvent.get("cpf")
    if not cpf:
        token = generate_jwt_token()
        return generate_response(token)

    cursor = connection.cursor()

    try:
        query = "SELECT * FROM cliente WHERE cpf = %s"
        cursor.execute(query, (cpf,))
        results = cursor.fetchone()
        if not results:
            token = generate_jwt_token(cpf=cpf)
            return generate_response(token)

        token = generate_jwt_token(results[0], results[1], cpf)
        return generate_response(token)

    except Exception as e:
        print(f"Exception: {str(e)}")
        connection.rollback()
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({"error": "Internal Server Error"})
        }

    finally:
        cursor.close()
        connection.commit()


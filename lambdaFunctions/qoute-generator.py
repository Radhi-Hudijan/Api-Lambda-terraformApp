import json
import random

def lambda_handler(event, context):
    quotes = [
    "Be yourself; everyone else is already taken. - Oscar Wilde",
    "Stay hungry, stay foolish. - Steve Jobs",
    "Less is more. - Ludwig Mies van der Rohe",
    "Life is short, and it's up to you to make it sweet. - Sarah Louise Delany",
    "Act as if what you do makes a difference. It does. - William James"]

    rondom_qoute = random.choice(quotes)

   
    return {
        'statusCode': 200,
        'body': "here is your qoute for today : " +  rondom_qoute
    }

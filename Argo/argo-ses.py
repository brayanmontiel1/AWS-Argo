import boto3
import datetime as dt
from datetime import date, time, datetime
from botocore.exceptions import ClientError

today = dt.date.today() #todays date
lastWeek = today - dt.timedelta(days=7)  #week ago date

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('argo-videos') #reference dynamoDB table

#scan for table
response = table.scan()
data = response['Items']

#validate
while 'LastEvaluatedKey' in response:
    response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
    data.extend(response['Items'])

# Replace sender@example.com with your "From" address.
# This address must be verified with Amazon SES.
SENDER = "Brayan Montiel <montibr@amazon.com>"

# Replace recipient@example.com with a "To" address. If your account 
# is still in the sandbox, this address must be verified.
RECIPIENT = "montibr@amazon.com"

# Specify a configuration set. If you do not want to use a configuration
# set, comment the following variable, and the 
# ConfigurationSetName=CONFIGURATION_SET argument below.
#CONFIGURATION_SET = "ConfigSet"

# If necessary, replace us-west-2 with the AWS Region you're using for Amazon SES.
AWS_REGION = "us-west-2"

# The subject line for the email.
SUBJECT = "MARKETING : Weekly Argo Video Report Now Available. " + str(lastWeek) + " to " + str(today) + "."

# The email body for recipients with non-HTML email clients.
BODY_TEXT = ("Your weekly video uploads\r\n"
             "This email was sent with Amazon SES using the "
             "AWS SDK for Python (Boto)."
            )
            
# The HTML body of the email.
BODY_HTML = """<html>
<head></head>
<body>
  <h1><center>Argo's weekly video uploads</center></h1>
  <p>You have a total of 
"""
BODY_HTML += str(len(data))
BODY_HTML += " new videos.  Details are shown below. <br/><br/>"
for record in data:
    BODY_HTML += "NAME:  " + record['VideoTitles'] + "  -- DATE: " + record['DateCompleted'] + "  -- TIME: " + record['TimeCompleted'] + "<br/>"

BODY_HTML += """</body>
</html>
"""
      

# The character encoding for the email.
CHARSET = "UTF-8"

# Create a new SES resource and specify a region.
client = boto3.client('ses',region_name=AWS_REGION)

# Try to send the email.
try:
    #Provide the contents of the email.
    response = client.send_email(
        Destination={
            'ToAddresses': [
                RECIPIENT,
            ],
        },
        Message={
            'Body': {
                'Html': {
                    'Charset': CHARSET,
                    'Data': BODY_HTML,
                },
                'Text': {
                    'Charset': CHARSET,
                    'Data': BODY_TEXT,
                },
            },
            'Subject': {
                'Charset': CHARSET,
                'Data': SUBJECT,
            },
        },
        Source=SENDER,
        # If you are not using a configuration set, comment or delete the
        # following line
        #ConfigurationSetName=CONFIGURATION_SET,
    )
# Display an error if something goes wrong.	
except ClientError as e:
    print(e.response['Error']['Message'])
else:
    print("Email sent! Message ID:"),
    print(response['MessageId'])
    
#clear table for next week entries
scan = table.scan()
with table.batch_writer() as batch:
    for each in scan['Items']:
        batch.delete_item(
            Key={
                'VideoTitles': each['VideoTitles'],
                'DateCompleted': each['DateCompleted']
            }
        )
import json
import boto3
import base64

s3_client = boto3.client('s3')
client = boto3.client('rekognition')

def lambda_handler(event, context):
    bucket_name = '5120tp19'
    file_name = event['filename']
    # arr = bytes(string, 'utf-8')
    # file_content =base64.decode(event['content'])
    file_content =base64.b64decode(event['content'])
    try:
        response1 = s3_client.put_object(
            Body=file_content,
            Bucket=bucket_name,
            Key=file_name
        )
        message1 = f"Image {file_name} uploaded to S3 bucket {bucket_name} successfully"
    except Exception as e:
        message1 = f"Error uploading image to S3 bucket: {e}"
        response1 = {
            "statusCode": 500,
            "body": {"message": message1}
        }
    else:
        response1 = {
            "statusCode": 200,
            "body": {"message": message1}
        }
    try:
        labels = client.detect_labels(Image={'S3Object':{'Bucket':bucket_name,'Name':file_name}},
        MaxLabels=5,
         # Uncomment to use image properties and filtration settings
         #Features=["GENERAL_LABELS", "IMAGE_PROPERTIES"],
         Settings={"GeneralLabels": {"LabelExclusionFilters":["Animal","Mammal", "Wildlife","Pet"]}}
         # "ImageProperties": {"MaxDominantColors":10}})
        )
        result = []
        all_label = []
        for label in labels['Labels']:
            result.append({"Name": label['Name'], "Confidence": label['Confidence']})
            all_label.append(label['Name'])
        if all_label == []:
            message2 = 'Nothing is detected properly in the image.'
        elif "Possum" in all_label:
            possum_confidence = round([x["Confidence"] for x in result if x["Name"] == "Possum"][0],4)
            if possum_confidence >= 80:
                message2 = f"The probability of the object in the image being a possum is: {possum_confidence}%. The detected object is highly believed to be a possum."
            elif 70<= possum_confidence < 80:
                message2 = f"The probability of the object in the image being a possum is: {possum_confidence}%. The detected object is mediumly belived as a possums. It is suggested to upload more images for a more accurate response."
            else:
                message2 = f"The probability of the object in the image being a possum is: {possum_confidence}%. It is strongly recommended to upload and test more images before making decisions."
        else:
            names = [x["Name"] for x in result]
            message2 =f"It seems no possum in the image. \n The detected object can be: {', '.join(names).lower()}. Please upload another image for checking possums."
    except Exception as e:
        message2 = f"Error detecing labels for the image: {e}"
        response2 = {
            "statusCode": 500,
            "body": {"message": message2}}
    else:
        response2 = {
            "statusCode": 200,
            "body": {"message": message2}}
    #responses = json.dumps({"responses": {"uploading":response1, "detecting": response2}})
    responses = {"responses": {"uploading":response1, "detecting": response2}}
    s3_client.delete_object(Bucket=bucket_name, Key=file_name)
    return responses

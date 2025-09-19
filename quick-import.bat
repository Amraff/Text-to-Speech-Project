@echo off
cd terraform
echo Importing resources...
terraform import aws_dynamodb_table.posts polly-posts-karim-final
terraform import aws_iam_role.lambda_new_post_role lambda-new-post-role-karim-final  
terraform import aws_iam_role.lambda_convert_role lambda-convert-role-karim-final
terraform import aws_iam_role.lambda_get_role lambda-get-role-karim-final
terraform import aws_s3_bucket.mp3_bucket text2speech-karim-final-9876
echo Done importing. Now run terraform apply.
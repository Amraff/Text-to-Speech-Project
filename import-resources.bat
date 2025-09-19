@echo off
cd terraform

echo Importing existing resources...

terraform import aws_dynamodb_table.posts polly-posts-karim-final 2>nul || echo DynamoDB table already imported or doesn't exist
terraform import aws_iam_role.lambda_new_post_role lambda-new-post-role-karim-final 2>nul || echo IAM role lambda_new_post_role already imported or doesn't exist
terraform import aws_iam_role.lambda_convert_role lambda-convert-role-karim-final 2>nul || echo IAM role lambda_convert_role already imported or doesn't exist
terraform import aws_iam_role.lambda_get_role lambda-get-role-karim-final 2>nul || echo IAM role lambda_get_role already imported or doesn't exist
terraform import aws_s3_bucket.mp3_bucket text2speech-karim-final-9876 2>nul || echo S3 bucket already imported or doesn't exist

echo Import complete. Now run terraform apply.
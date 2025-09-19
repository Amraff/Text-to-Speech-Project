@echo off
cd terraform

echo Importing existing resources...

terraform import aws_dynamodb_table.posts polly-posts-karim-v3
terraform import aws_iam_role.lambda_new_post_role lambda-new-post-role-karim-v3
terraform import aws_iam_role.lambda_convert_role lambda-convert-role-karim-v3
terraform import aws_iam_role.lambda_get_role lambda-get-role-karim-v3
terraform import aws_s3_bucket.mp3_bucket text2speech-karim-20250919-unique5678

echo Import complete. Now run terraform apply.
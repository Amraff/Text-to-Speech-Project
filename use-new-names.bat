@echo off
echo Updating resource names to avoid conflicts...

powershell -Command "(Get-Content terraform\terraform.tfvars) -replace 'polly-posts-karim-v3', 'polly-posts-karim-final' -replace 'polly-post-topic-karim-v3', 'polly-post-topic-karim-final' -replace 'text2speech-karim-20250919-unique5678', 'text2speech-karim-final-9876' | Set-Content terraform\terraform.tfvars"

powershell -Command "(Get-Content terraform\lambda.tf) -replace 'polly-new-post-karim-v3', 'polly-new-post-karim-final' -replace 'polly-convert-audio-karim-v3', 'polly-convert-audio-karim-final' -replace 'polly-get-post-karim-v3', 'polly-get-post-karim-final' | Set-Content terraform\lambda.tf"

powershell -Command "(Get-Content terraform\iam.tf) -replace 'lambda-new-post-role-karim-v3', 'lambda-new-post-role-karim-final' -replace 'lambda-convert-role-karim-v3', 'lambda-convert-role-karim-final' -replace 'lambda-get-role-karim-v3', 'lambda-get-role-karim-final' | Set-Content terraform\iam.tf"

powershell -Command "(Get-Content terraform\apigw.tf) -replace 'polly-api-karim-v3', 'polly-api-karim-final' | Set-Content terraform\apigw.tf"

echo Resource names updated. Now run terraform apply.
@echo off
echo Checking existing API Gateways...
aws apigateway get-rest-apis --query "items[?contains(name, 'polly')].{Name:name,Id:id}" --output table
echo.
echo If you see an API above, use its ID to build the URL:
echo https://[API-ID].execute-api.us-east-1.amazonaws.com/prod
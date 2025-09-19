@echo off
cd terraform
for /f "tokens=*" %%i in ('terraform output -raw api_base_url') do set API_URL=%%i
cd ..
powershell -Command "(Get-Content website\scripts.js) -replace 'var API_BASE_URL = \".*\";', 'var API_BASE_URL = \"%API_URL%\";' | Set-Content website\scripts.js"
echo Updated API URL to: %API_URL%
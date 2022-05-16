@echo off
set ARG=%1
IF NOT "%ARG%" == "--get-secrets" goto main

@echo on
echo Fetching secrets...

@echo on
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="KEYCLOAK_ADMIN"') do (SET KEYCLOAK_ADMIN=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="KEYCLOAK_ADMIN_PASSWORD"') do (SET KEYCLOAK_ADMIN_PASSWORD=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="MYSQL_DB_HOST"') do (SET MYSQL_DB_HOST=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="MYSQL_DB_PORT"') do (SET MYSQL_DB_PORT=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="KEYCLOAK_MYSQL_DBNAME"') do (SET KEYCLOAK_MYSQL_DBNAME=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="KEYCLOAK_MYSQL_USER"') do (SET KEYCLOAK_MYSQL_USER=%%g)
FOR /F "tokens=*" %%g IN ('gcloud secrets versions access latest --secret="KEYCLOAK_MYSQL_USER_PASS"') do (SET KEYCLOAK_MYSQL_USER_PASS=%%g)

:main

set gcpKeyFilePath=/tmp/keys/gcp-key.json
set image=custom-keycloak-local

REM set image=asia-south2-docker.pkg.dev/saml-test-setup/cloud-run-docker-images/custom-keycloak:dev

@echo on
docker build -t %image% .

@echo off
if %errorlevel% neq 0 exit /b %errorlevel%

set MYSQL_DB_HOST="34.131.54.65"
set KEYCLOAK_MYSQL_USER_PASS=";j%TJSRqr7+@#bY0"

@echo on
docker rm -f my_keycloak
docker run -d -e PROXY_ADDRESS_FORWARDING=true -e KEYCLOAK_LOGLEVEL=INFO -e ROOT_LOGLEVEL=INFO -e
KEYCLOAK_ADMIN=%KEYCLOAK_ADMIN% -e
KEYCLOAK_ADMIN_PASSWORD=%KEYCLOAK_ADMIN_PASSWORD% -e DB_HOST=%MYSQL_DB_HOST% -e DB_PORT=%MYSQL_DB_PORT% -e DB_DATABASE=%KEYCLOAK_MYSQL_DBNAME% -e DB_USER=%KEYCLOAK_MYSQL_USER% -e DB_PASSWORD=%KEYCLOAK_MYSQL_USER_PASS% -e K_CONFIGURATION=dev -e GOOGLE_APPLICATION_CREDENTIALS=%gcpKeyFilePath% -v %GOOGLE_APPLICATION_CREDENTIALS%:%gcpKeyFilePath% -p 8080:8080 --name my_keycloak %image%
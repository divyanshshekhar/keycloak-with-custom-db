docker build -t custom-keycloak ./
docker tag custom-keycloak asia-south2-docker.pkg.dev/saml-test-setup/cloud-run-docker-images/custom-keycloak:dev
docker push asia-south2-docker.pkg.dev/saml-test-setup/cloud-run-docker-images/custom-keycloak:dev
gcloud run deploy custom-keycloak --min-instances=1 --max-instances=1 --port=8080 --tag=keycloak --set-secrets=KEYCLOAK_ADMIN=KEYCLOAK_ADMIN:latest,KEYCLOAK_ADMIN_PASSWORD=KEYCLOAK_ADMIN_PASSWORD:latest,DB_HOST=MYSQL_DB_HOST:latest,DB_PORT=MYSQL_DB_PORT:latest,DB_DATABASE=KEYCLOAK_MYSQL_DBNAME:latest,DB_USER=KEYCLOAK_MYSQL_USER:latest,DB_PASSWORD=KEYCLOAK_MYSQL_USER_PASS:latest --image=asia-south2-docker.pkg.dev/saml-test-setup/cloud-run-docker-images/custom-keycloak:dev --region=asia-south2 --memory=1Gi

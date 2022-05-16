docker rm my_keycloak
docker build -t custom-keycloak . 
docker run -d -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password -p 8080:8080 --name my_keycloak custom-keycloak
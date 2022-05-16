FROM quay.io/keycloak/keycloak:latest as builder

# Install custom providers
ADD providers /opt/keycloak/providers
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar

# Override configuration
#ADD conf/keycloak.conf /opt/keycloak/conf/

# Setup environment
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
#ENV PROXY_ADDRESS_FORWARDING=true

RUN /opt/keycloak/bin/kc.sh build --db=mysql

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
#RUN keytool -genkeypair -storepass jdsdjalsdi232$ -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
#ENV PROXY_ADDRESS_FORWARDING=true
ENTRYPOINT [ \
    "/opt/keycloak/bin/kc.sh", \
    "start", \
    "--proxy=edge", \
    "--hostname-strict=false", \
    "--http-enabled=true", \
    #"--db=$DB_VENDOR", \
    "--db-url-host=${DB_HOST}", \
    "--db-url-port=${DB_PORT}", \
    "--db-url-database=${DB_DATABASE}", \
    "--db-username=$DB_USER", \
    "--db-password=$DB_PASSWORD" \
]

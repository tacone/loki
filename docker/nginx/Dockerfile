FROM  fholzer/nginx-brotli

RUN apk update && \
    apk add --no-cache openssl && \
    openssl req -x509 -nodes -days 365 \
    -subj  "/C=CA/ST=QC/O=Company Inc/CN=example.com" \
     -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key \
     -out /etc/ssl/certs/nginx-selfsigned.crt;
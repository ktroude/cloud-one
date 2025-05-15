FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/selfsigned.key \
    -out /etc/nginx/ssl/selfsigned.crt \
    -subj "/CN=localhost"

COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

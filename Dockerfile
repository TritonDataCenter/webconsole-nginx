FROM nginx:1.12.2-alpine
ARG NAV_VER=2.2.0

RUN apk update \
    && apk add --update bash curl \
    && apk upgrade \
    && rm -rf /var/cache/apk/*

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY bin/entrypoint.sh /bin/entrypoint.sh
RUN chmod 700 /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx"]

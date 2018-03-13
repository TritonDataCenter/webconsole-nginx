FROM nginx:1.12.2-alpine

RUN apk update \
    && apk add --update bash \
    && apk upgrade \
    && rm -rf /var/cache/apk/*

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY bin/entrypoint.sh /bin/entrypoint.sh
RUN chmod 700 /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx"]

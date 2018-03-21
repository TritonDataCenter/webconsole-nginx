FROM nginx:1.12.2-alpine
ARG NAV_VER=2.2.0

RUN apk update \
    && apk add --update bash curl \
    && apk upgrade \
    && rm -rf /var/cache/apk/*

COPY etc/nginx.conf /etc/nginx/nginx.conf
COPY bin/entrypoint.sh /bin/entrypoint.sh
RUN chmod 700 /bin/entrypoint.sh

# Download static assets for /navigation
RUN mkdir -p /opt/www/navigation && \
    curl -k https://registry.npmjs.org/my-joy-navigation/-/my-joy-navigation-$NAV_VER.tgz > /tmp/my-joy-navigation-$NAV_VER.tgz && \
    tar -C /tmp -zxf /tmp/my-joy-navigation-$NAV_VER.tgz && \
    mv /tmp/package/build/* /opt/www/navigation && \
    rm -rf /tmp/package

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx"]

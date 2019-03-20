FROM ubuntu:18.04

MAINTAINER MiRacLe "miracle@rpz.name"

ENV TZ 'Europe/Moscow'

RUN apt-get update && apt-get install ca-certificates gnupg curl tzdata locales --no-install-recommends --no-install-suggests -y \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install php7.2-fpm php7.2-curl php7.2-gd php7.2-soap php7.2-mbstring php7.2-curl php7.2-bcmath php7.2-sqlite3 php7.2-intl php7.2-apcu php-redis php-xdebug -y \
    && phpdismod xdebug \
        apt-get install -y locales \
    && locale-gen en_US.UTF-8

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
        && apt-get update \
        && ACCEPT_EULA=Y apt-get install msodbcsql17 mssql-tools unixodbc-dev --no-install-recommends --no-install-suggests -y \
        && apt-get install php7.2-dev php-pear -y \
    && ln -s /opt/mssql-tools/bin/sqlcmd /usr/local/bin/sqlcmd \
    && ln -s /opt/mssql-tools/bin/bcp /usr/local/bin/bcp

# required (temporary?!) libssl1.0 (https://github.com/Microsoft/msphpsql/issues/745#issuecomment-464273936)
RUN curl http://security-cdn.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb --output libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb \
    && dpkg -i libssl1.0.0_1.0.1t-1+deb8u10_amd64.deb

RUN pecl install sqlsrv-5.6.1 \
    && echo "[sqlsrv]" >> /etc/php/7.2/mods-available/sqlsrv.ini \
    && echo "extension=sqlsrv.so" >> /etc/php/7.2/mods-available/sqlsrv.ini \
    && echo "sqlsrv.ClientBufferMaxKBSize = 102400" >> /etc/php/7.2/mods-available/sqlsrv.ini \
    && phpenmod sqlsrv


RUN rm -rf /usr/src/* \
    rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove \
    && apt-get autoclean


WORKDIR /var/www

VOLUME /var/www

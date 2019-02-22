FROM ubuntu:18.04

MAINTAINER MiRacLe "miracle@rpz.name"

ENV TZ 'Europe/Moscow'

RUN apt-get update && apt-get install ca-certificates gnupg curl tzdata --no-install-recommends --no-install-suggests -y \
    && dpkg-reconfigure -f noninteractive tzdata \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \ 
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install libssl1.0 msodbcsql17 mssql-tools unixodbc-dev --no-install-recommends --no-install-suggests -y \
    && apt-get install php-pear php7.2-dev php7.2-fpm php7.2-curl php7.2-gd php7.2-soap php7.2-mbstring php7.2-curl php7.2-bcmath php7.2-sqlite3 -y \
    && ln -s /opt/mssql-tools/bin/sqlcmd /usr/local/bin/sqlcmd \
    && ln -s /opt/mssql-tools/bin/bcp /usr/local/bin/bcp

RUN echo '' | pecl install apcu \
    && echo "[apcu]" >> /etc/php/7.2/mods-available/apcu.ini \
    && echo "extension=apcu.so" >> /etc/php/7.2/mods-available/apcu.ini \
    && echo "apc.shm_size = 128M" >> /etc/php/7.2/mods-available/apcu.ini \
    && phpenmod apcu
    
RUN pecl install redis \
    && echo "[redis]" >> /etc/php/7.2/mods-available/redis.ini \
    && echo "extension=redis.so" >> /etc/php/7.2/mods-available/redis.ini \
    && phpenmod redis

RUN pecl install xdebug

# generate locales
RUN apt-get install -y locales \
    && locale-gen en_US.UTF-8


RUN pecl install sqlsrv-5.6.0 \
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

FROM ubuntu:16.04

MAINTAINER MiRacLe "miracle@rpz.name"

RUN apt-get update -y && apt-get install apt-transport-https \
    php-pear php7.0-dev php7.0-fpm php7.0-curl php7.0-gd php7.0-soap php7.0-mbstring php7.0-mcrypt php7.0-curl php7.0-bcmath php7.0-sqlite3 -y \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update -y \
    && apt-get upgrade -y \
    && ACCEPT_EULA=Y apt-get install msodbcsql mssql-tools unixodbc-dev \
    --no-install-recommends \
    --no-install-suggests \
    -y \
    && ln -s /opt/mssql-tools/bin/sqlcmd /usr/local/bin/sqlcmd \
    && ln -s /opt/mssql-tools/bin/bcp /usr/local/bin/bcp

RUN echo '' | pecl install apcu \
    && echo "[apcu]" >> /etc/php/7.0/mods-available/apcu.ini \
    && echo "extension=apcu.so" >> /etc/php/7.0/mods-available/apcu.ini \
    && echo "apc.shm_size = 128M" >> /etc/php/7.0/mods-available/apcu.ini \
    && phpenmod apcu
    
RUN pecl install redis \
    && echo "[redis]" >> /etc/php/7.0/mods-available/redis.ini \
    && echo "extension=redis.so" >> /etc/php/7.0/mods-available/redis.ini \
    && phpenmod redis

RUN pecl install xdebug

# generate locales
RUN apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && locale-gen ru_RU.CP1251


RUN pecl install sqlsrv-5.2.0RC \
    && echo "[sqlsrv]" >> /etc/php/7.0/mods-available/sqlsrv.ini \
    && echo "extension=sqlsrv.so" >> /etc/php/7.0/mods-available/sqlsrv.ini \
    && echo "sqlsrv.ClientBufferMaxKBSize = 102400" >> /etc/php/7.0/mods-available/sqlsrv.ini \
    && phpenmod sqlsrv
    


RUN rm -rf /usr/src/* \
    rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove \
    && apt-get autoclean


WORKDIR /var/www

VOLUME /var/www

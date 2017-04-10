FROM ubuntu:16.04

MAINTAINER MiRacLe "miracle@rpz.name"

RUN apt-get update -y && apt-get install apt-transport-https \
    php-pear php7.0-dev php7.0-fpm php7.0-curl php7.0-gd php7.0-soap php7.0-mbstring php7.0-mcrypt php7.0-curl php7.0-bcmath php7.0-sqlite3 -y \
    &&  echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/mssql-ubuntu-xenial-release/ xenial main" > /etc/apt/sources.list.d/mssqlpreview.list \
    && apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 \
    && apt-get update -y \
    && apt-get upgrade -y \
    && ACCEPT_EULA=Y apt-get install msodbcsql unixodbc-dev-utf16 \
    --no-install-recommends \
    --no-install-suggests \
    -y 

RUN echo '' | pecl install apcu \
    && echo "[apcu]" >> /etc/php/7.0/mods-available/apcu.ini \
    && echo "extension=apcu.so" >> /etc/php/7.0/mods-available/apcu.ini \
    && echo "apc.shm_size = 128M" >> /etc/php/7.0/mods-available/apcu.ini \
    && phpenmod apcu


# generate UTF8 locales (#161)
RUN apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen


RUN pecl install sqlsrv-4.1.8preview \
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

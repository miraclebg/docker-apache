ARG APP_ID=1000

FROM ubuntu:14.04

ARG APP_ID

LABEL maintainer="Martin Kovachev <miracle@nimasystems.com>"

# disable interactive functions
ENV DEBIAN_FRONTEND=noninteractive
ENV APACHE_RUN_USER=app
ENV APACHE_RUN_GROUP=app

USER root

RUN apt-get update \
  && apt-get install -y apache2 curl acl locales ImageMagick gettext wget \
    php5 libapache2-mod-php5 \
    php5-cli php5-mysqlnd php5-pgsql php5-intl php5-sqlite php5-redis php5-xsl php5-geoip \
    php5-apcu php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl php5-imap \
    php5-memcache php5-memcached php5-redis \
  && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'es_ES.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'bg_BG.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'it_IT.UTF-8 UTF-8' >> /etc/locale.gen \
  && echo 'ru_RU.UTF-8 UTF-8' >> /etc/locale.gen \
  && /usr/sbin/locale-gen

RUN groupadd -g "$APP_ID" app \
    && useradd -g "$APP_ID" -u "$APP_ID" -d /var/www -s /bin/bash app \
    && mkdir -p /var/log/apache2 && chown -R app:app /var/log/apache2 /var/www/html /var/run/apache2 /var/lock/apache2

RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN rm -rf /tmp/pear /var/cache/apt /var/lib/apt/lists/*

USER app:app
WORKDIR /var/www/html
EXPOSE 80
CMD ["apachectl", "-D FOREGROUND"]
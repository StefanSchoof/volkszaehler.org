# Copyright (c) 2019 Andreas Goetz <cpuidle@gmx.de>

FROM composer:1 AS builder

WORKDIR /vz

COPY composer.json /vz

RUN composer install --no-ansi --no-scripts --no-dev --no-interaction --no-progress --optimize-autoloader

COPY . /vz


FROM php:7.3-alpine

EXPOSE 8080
EXPOSE 8082
EXPOSE 5582

RUN apk add postgresql-dev
RUN docker-php-ext-install pcntl pdo_mysql pdo_pgsql

COPY --from=builder /vz /vz
COPY --from=builder /vz/etc/config.dist.yaml /vz/etc/config.yaml
COPY --from=builder /vz/docker/volkszaehler-start.sh /usr/local/bin/volkszaehler

# modify options.js
RUN sed -i "s/url: 'api'/url: '',/" /vz/htdocs/js/options.js

CMD ["volkszaehler"]

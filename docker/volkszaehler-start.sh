#!/bin/sh
set -e

VZ_PPM_WORKER_COUNT=${VZ_PPM_WORKER_COUNT:-8}
VZ_DOCTRINE_CREATE_OR_UPDATE=${VZ_DOCTRINE_CREATE_OR_UPDATE:-false}

if [ "$VZ_DOCTRINE_CREATE_OR_UPDATE" = "true" ]; then
    /vz/bin/doctrine orm:schema-tool:update --force || /vz/bin/doctrine orm:schema-tool:create
fi

/vz/vendor/bin/ppm start -c /vz/etc/middleware.json --static-directory /vz/htdocs --cgi-path=/usr/local/bin/php  --workers=$VZ_PPM_WORKER_COUNT

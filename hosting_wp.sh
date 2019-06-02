#!/bin/bash
USER="$1"
DOMAIN="$2"
DB_NAME="wp"

WP_FILES="/var/wp"
WP_PATH="$5"

DB_PASSWORD="$(cat $WP_FILES/.dbpass)"

if [ ! -f "$WP_FILES"/wordpress.zip ]; then
	wget -O "$WP_FILES"/wordpress.zip https://wordpress.org/latest.zip
fi

if [ ! -f "$WP_FILES"/woocommerce.zip ]; then
	wget -O "$WP_FILES"/woocommerce.zip https://github.com/woocommerce/woocommerce/archive/3.6.3.zip
fi

if [ ! -f "$WP_FILES"/assistant.zip ]; then
	wget -O "$WP_FILES"/assistant.zip https://s3.amazonaws.com/justfreethemes/utils/jft-assitant-plugin/latest/jft-assitant-plugin.zip
fi

cp "$WP_FILES"/wordpress.zip "$WP_PATH/" || exit 1

cd "$WP_PATH" || exit 1

rm index.php

unzip -q wordpress.zip

mv wordpress/* .
rmdir wordpress

echo "<?php
define('DB_NAME', '${USER}_${DB_NAME}');
define('DB_USER', '${USER}_${DB_NAME}');
define('DB_PASSWORD', '${DB_PASSWORD}');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
$(curl https://api.wordpress.org/secret-key/1.1/salt/)

\$table_prefix  = 'wp_';

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');" > wp-config.php

cd wp-content/plugins || exit

cp "$WP_FILES"/woocommerce.zip . || exit 1
cp "$WP_FILES"/assistant.zip . || exit 1

unzip -q woocommerce.zip
rm woocommerce.zip
unzip -q assistant.zip
rm assistant.zip

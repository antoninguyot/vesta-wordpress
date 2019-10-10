#!/bin/bash

USER="$1"
DB_NAME="wp"
WP_FILES="/tmp/wp"
WP_PATH="$5"

DB_PASSWORD="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)"

mkdir -p "$WP_FILES"

if [ ! -f "$WP_FILES"/wordpress.zip ]; then
	wget -O "$WP_FILES"/wordpress.zip https://wordpress.org/latest.zip
fi

if [ ! -f "$WP_FILES"/woocommerce.zip ]; then
	wget -O "$WP_FILES"/woocommerce.zip https://github.com/woocommerce/woocommerce/archive/3.7.1.zip
fi

if [ ! -f "$WP_FILES"/assistant.zip ]; then
	wget -O "$WP_FILES"/assistant.zip https://s3.amazonaws.com/justfreethemes/utils/jft-assitant-plugin/latest/jft-assitant-plugin.zip
fi

cp "$WP_FILES"/wordpress.zip "$WP_PATH/" || exit 1

cd "$WP_PATH" || exit 1

rm -f index.html

unzip -q wordpress.zip

mv wordpress/* .
rmdir --ignore-fail-on-non-empty wordpress

# DB creation
/usr/local/vesta/bin/v-add-database "$USER" "$DB_NAME" "wp" "$DB_PASSWORD"

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
require_once(ABSPATH . 'wp-settings.php');
require_once(ABSPATH . 'ateros-config.php');" > wp-config.php

curl https://raw.githubusercontent.com/anto2oo/ateros-wordpress/master/ateros-config.php > ateros-config.php

cd wp-content/plugins || exit

cp -f "$WP_FILES"/woocommerce.zip . || exit 1
cp -f "$WP_FILES"/assistant.zip . || exit 1

unzip -q woocommerce.zip
rm -f woocommerce.zip
unzip -q assistant.zip
rm -f assistant.zip

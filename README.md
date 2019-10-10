# vesta-wordpess

### About
These files are used to setup and configure a wordpress installation everytime a new website is create through Vesta with these templates.

The script installs Wordpress and Woocommerce, and automatically applies the Ateros Textile configuration file to Wordpress.

### Installation

System requirements :

- unzip
- wget

All files should be put under
`/usr/local/vesta/data/templates/web/httpd/`  
on RHEL or 
`/usr/local/vesta/data/templates/web/apache2/`  
on other systems.

**Note** : this software is intended to run on Centos 7. However, it will probably run without problems on other systems. In case something doesn't work, just copy the original "hosting" file templates from Vesta :
 ```
cp /usr/local/vesta/data/templates/web/apache2/hosting.tpl /usr/local/vesta/data/templates/web/apache2/hosting_wp.tpl
cp /usr/local/vesta/data/templates/web/apache2/hosting.stpl /usr/local/vesta/data/templates/web/apache2/hosting_wp.stpl
```

### Usage

Once the files are located under the right directory, you should be able to create a new Vesta package using this template.
Then, everytime you create a new website using this package, wordpress will be installed and a database named $USER_wp will automatically be created.

**Important** : one website can be created by user ONLY. If you create more than one website for the same user, the database creation WILL FAIL. (because all databases are named $USER_wp) 
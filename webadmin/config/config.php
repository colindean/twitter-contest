<?php
/*************************
**
** Configuration file for web admin
**
*************************/

//Paths must be relevant to the www directory
$config->www_dir = getcwd();
$config->admin_dir = $config->www_dir.DIRECTORY_SEPARATOR."..".DIRECTORY_SEPARATOR;

//Path to the database file since we're using sqlite for now
//   use this one for sqlite
//$config->database_dsn = 'sqlite://'.$config->www_dir.'/../../database/contest.db';
//   use this one for mysql, but make sure the user:password@hostname/database is correct
$config->database_dsn = 'mysql:host=localhost;dbname=twcon';
$config->database_user = 'twcon';
$config->database_password = 'ycL7JYNCcTvnu3qL';
$config->database_options = array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8");

//smarty variables
$config->smarty_template_dir = $config->admin_dir.'/templates/';
$config->smarty_compile_dir = $config->admin_dir.'/var/templates_c/';
$config->smarty_config_dir = $config->admin_dir.'/config/';
$config->smarty_cache_dir = $config->admin_dir.'/var/cache/';
$config->smarty_plugins_dir = $config->admin_dir.'/var/plugins';
$config->app_title = "Twitter Contest Results";
?>

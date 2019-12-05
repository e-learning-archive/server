<?php
$global['webSiteRootURL'] = 'http://ENCODER_HOSTNAME/';
$global['systemRootPath'] = '/var/www/html/';

$global['disableConfigurations'] = false;
$global['disableBulkEncode'] = false;
$global['disableWebM'] = false;

$mysqlHost = 'db';
$mysqlUser = 'MYSQL_USER';
$mysqlPass = 'MYSQL_PASSWORD';
$mysqlDatabase = 'encoder';

$global['allowed'] = array('mp4', 'avi', 'mov', 'flv', 'mp3', 'wav', 'm4v', 'webm', 'wmv', 'mpg', 'mpeg', 'f4v', 'm4v', 'm4a', 'm2p', 'rm', 'vob', 'mkv', '3gp');
/**
 * Do NOT change from here
 */

require_once $global['systemRootPath'].'objects/include_config.php';

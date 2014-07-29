<?php
require_once('..'.DIRECTORY_SEPARATOR.'lib'.DIRECTORY_SEPARATOR.'includes.php');
/******************
** Bootstrap and route
******************/
$config = Config::getInstance();
require_once("../config/config.php");

$dummy = Dummy::getInstance();
$dummy->setup($config);

//let's get down to business.

//do everything php side for now.

//first, we need to load all of the contest entries
$entries = ContestEntry::loadByTimestamp(ContestEntry::LOAD_DESC);

$dummy->assign("entries", $entries);


//meta
$dummy->assign("app_title", $config->app_title);
$dummy->assign("page_title", 'Overview');

//dispatch
$dummy->display("index.tpl");
?>

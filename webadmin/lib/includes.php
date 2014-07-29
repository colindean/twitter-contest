<?php
$lib_path = "..".DIRECTORY_SEPARATOR."lib".DIRECTORY_SEPARATOR;
$external_path = "..".DIRECTORY_SEPARATOR."external".DIRECTORY_SEPARATOR;

//Config class is top dog
require_once($lib_path."Config.class.php");

//Smarty
//need an external first
require_once($external_path."smarty/libs/Smarty.class.php");
require_once($lib_path."Dummy.class.php");

//ContestEntry
require_once($lib_path."ContestEntry.class.php");

?>

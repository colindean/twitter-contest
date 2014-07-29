<?php
/************************
** Config class 
************************/
class Config {
	static private $_instance;
	static private $_database;

	public function __construct(){
		//$this->database = new PDO($;
		$this->database_dsn = '';
		$this->smarty = array();
	}

	public function db(){
		if(!$this->database_dsn)
			throw new Exception('$config->database_dsn not defined in config');
		if(!self::$_database)
			self::$_database = new PDO($this->database_dsn, $this->database_user, $this->database_password, $this->database_options);
		return self::$_database;
	}

	static function getInstance(){
		if(!self::$_instance){
			self::$_instance = new Config();
		}
		return self::$_instance;
	}
}
?>

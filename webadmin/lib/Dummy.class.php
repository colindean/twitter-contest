<?php

class Dummy extends Smarty {

	private static $_instance = null;
	private $i = null;

	public function __construct(){
		parent::__construct();
		$this->allow_php_tag = true;
	}

	static function getInstance(){
		if(!self::$_instance){
			self::$_instance = new Dummy();
		}
		self::$_instance->i = self::$_instance;
		return self::$_instance;
	}

	/**
	 * Setup the Smarty paths
   *
	 * @param Config $config the configuration object
   * @return void
   */
	public function setup($config){
		$this->template_dir = $config->smarty_template_dir;
		$this->compile_dir = $config->smarty_compile_dir;
		$this->config_dir = $config->smarty_config_dir;
		$this->cache_dir = $config->smarty_cache_dir;
		//$this->plugins_dir = array('plugins', $config->smarty_plugins_dir);
	}	
}
?>

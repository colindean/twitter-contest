<?php
//Most of the functions of this class should be abstracted into a Model and DataAccess class. 

class ContestEntry {

	public $timestamp;
	public $username;
	public $text;
	public $id;

	const LOAD_ASC = 1;
	const LOAD_DESC = 0;

	public function __construct($ti, $u, $tx, $id){
		$this->timestamp = $ti;
		$this->username = $u;
		$this->text = $tx;
		$this->id = $id;
	}

	static function loadOne() {
		//returns a single instance
		throw new Exception(__METHOD__." not yet implemented");
	}

	static function loadMany($view='contest_entry', $where=null) {
		//returns an array
		$l = array();
		$db = Config::getInstance()->db();
		$smt = $db->query("SELECT * FROM $view $where");
		if(!$smt) {
			$argh = $db->errorInfo();
			echo $argh[2];
		}

		$smt->setFetchMode(PDO::FETCH_ASSOC);
		while($res = $smt->fetch()){
			$l[] = new self($res['timestamp'], $res['user'], $res['tweet'], $res['id']);
		}	
		$smt->closeCursor();
		return $l;
	}

	static function loadByTimestamp($asc_or_desc=0){
		if($asc_or_desc)
			return self::loadMany('all_asc');
		else
			return self::loadMany('all_desc');
	}

	static function loadByUsername($asc_or_desc=1){
		if($asc_or_desc)
			return self::loadMany('users_asc');
		else
			return self::loadMany('users_desc');

	}

	static function loadWithinDateRange($asc_or_desc=0, $start=PHP_DATE_MIN, $end=PHP_DATE_MAX){
		$db = Config::getInstance()->db();
		$where = sprintf("WHERE timestamp > %s AND timestamp < %s", 
											$db->quote($start), $db->quote($end));
		if($asc_or_desc)
			return self::loadMany('all_asc', $where);
		else
			return self::loadMany('all_desc', $where);
	

	}

	static function searchWithinText($text){
		$db = Config::getInstance()->db();
		$where = sprintf("WHERE tweet LIKE %%%s%%", 
											$db->quote($text));
		if($asc_or_desc)
			return self::loadMany('all_asc', $where);
		else
			return self::loadMany('all_desc', $where);
	}

}
?>

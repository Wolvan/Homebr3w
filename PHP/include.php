<?php
	$api_path = "https://api.titledb.com/";
	
	function http_req($data = array("action" => "list", "fields" => array("id", "titleid", "author", "description", "name", "create_time", "update_time", "size", "mtime")), $endpoint = "v0/", $use_get = false) {
		$curl = curl_init($GLOBALS["api_path"].$endpoint);
		if (!$use_get) { curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data)); }
		curl_setopt($curl, CURLOPT_POST, !$use_get);
		curl_setopt($curl, CURLOPT_HTTPGET, $use_get);
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($curl, CURLOPT_USERAGENT, "Homebr3w/1.0.0 Homebr3w-Proxy/1.0.1");
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$response = curl_exec($curl);
		curl_close($curl);
		return $response;
	}

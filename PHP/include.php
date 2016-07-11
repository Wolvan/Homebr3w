<?php
	$api_path = "https://api.titledb.com/";
	
	function http_req($data = array("action" => "list"), $endpoint = "v0/") {
		$curl = curl_init($GLOBALS["api_path"].$endpoint);
		$headers = array();
		$headers[] = "Homebr3w/1.0.0 Homebr3w-Proxy/1.0.0";
		curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($data));
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$response = curl_exec($curl);
		curl_close($curl);
		return $response;
	}
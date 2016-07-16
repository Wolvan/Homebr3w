<?php	
	header("Content-Disposition: attachment; filename=meta.json");
	header("Content-Type: application/force-download");
	header("Connection: close");

	function http($url) {
		$curl = curl_init($url);
		$headers = array();
		$headers[] = "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0";
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		$response = curl_exec($curl);
		curl_close($curl);
		return $response;
	}
	
	$release = json_decode(http("https://api.github.com/repos/Wolvan/Homebr3w/releases/latest"));
	
	if (!isset($release->tag_name)) {
		$release->tag_name = "v1.0.0";
	}
	
	$meta = array(
		"current_version" => $release->tag_name,
		"blacklisted" => array()
	);
	
	echo json_encode($meta);

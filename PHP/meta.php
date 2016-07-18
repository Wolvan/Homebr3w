<?php	
	header("Content-Disposition: attachment; filename=meta.json");
	header("Content-Type: application/force-download");
	header("Connection: close");

	$meta = array(
		"blacklisted" => array()
	);
	
	echo json_encode($meta);

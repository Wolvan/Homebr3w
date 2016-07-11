<?php
	include "include.php";

	if (isset($_GET["titleid"])) {
		$titleid = $_GET["titleid"];
	} else {
		$titleid = "0004000000130800"; // Default value so nothing breaks is my encTitleKeys.bin Updater
	}
	
	header("Content-Disposition: attachment; filename={$titleid}.cia");
	header("Content-Type: application/force-download");
	header("Connection: close");
	
	$cia = file_get_contents($api_path."v0/proxy/{$titleid}");
	
	echo $cia;

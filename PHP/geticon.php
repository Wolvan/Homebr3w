<?php
	include "include.php";

	$titleid = $_GET["titleid"];
	$size = strtolower($_GET["size"]);

	if (!$titleid) {
		$titleid = "0004000000130800";
	}
	if ($size !== "small" && $size !== "large") {
		$size = "small";
	}
	header("Content-Disposition: attachment; filename={$titleid}.txt");
	header("Content-Type: application/force-download");
	header("Connection: close");
	
	echo http_req(array("action" => "list", fields => array("icon_".$size), where => array("titleid" => $titleid)));

<?php
	include "include.php";

	header("Content-Disposition: attachment; filename=fields.json");
	header("Content-Type: application/force-download");
	header("Connection: close");


	echo http_req(array("action"=>"list_fields"));

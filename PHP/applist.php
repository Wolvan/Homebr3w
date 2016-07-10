<?php
	include "include.php";

	header("Content-Disposition: attachment; filename=applist.json");
	header("Content-Type: application/force-download");
	header("Connection: close");


	echo http_req();

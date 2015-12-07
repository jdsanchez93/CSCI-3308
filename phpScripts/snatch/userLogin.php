<?php

require("Conn.php");
require("MySQLDao.php");

$username = htmlentities($_POST["username"]);
$password = htmlentities($_POST["password"]);
$returnValue = array();

if(empty($username) || empty($password))
{
	$returnValue["status"] = "error";
	$returnValue["message"] = "Missing required field";
	echo json_encode($returnValue);
	return;
}

$secure_password = md5($password);

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetailsWithPassword($username,$secure_password);

if(!empty($userDetails))
{
	$returnValue["status"] = "Success";
	$returnValue["message"] = "User is registered";
	echo json_encode($returnValue);
} else {

	$returnValue["status"] = "error";
	$returnValue["message"] = "User is not found";
	echo json_encode($returnValue);
}

$dao->closeConnection();

?>

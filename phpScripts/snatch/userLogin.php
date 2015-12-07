<?php


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

try {
	$conn = new pdo('mysql:unix_socket=/cloudsql/caramel-howl-113305:snatch;dbname=snatch', 'root', '');
} catch(PDOException $ex) {
	die(json_encode(
    	array('status' => 'error', 'message' => 'Unable to connect')
    	)
	);
}

$returnValue = array();
$sql = "select count(*) from users where username='" . $username . "' and password='" .$secure_password . "'";

$result = $conn->query($sql);

if ($result->fetchColumn() == 1) {
	$returnValue["status"] = "Success";
	$returnValue["message"] = "User is registered";
	echo json_encode($returnValue);
} else {
	$returnValue["status"] = "error";
	$returnValue["message"] = "User is not found";
	echo json_encode($returnValue);
}


$conn = null;

?>

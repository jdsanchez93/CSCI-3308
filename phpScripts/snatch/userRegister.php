<?php 

$email = htmlentities($_POST["email"]);
$username = htmlentities($_POST["username"]);
$password = htmlentities($_POST["password"]);

$returnValue = array();

if(empty($email) || empty($username) || empty($password))
{
	$returnValue["status"] = "error";
	$returnValue["message"] = "Missing required field";
	echo json_encode($returnValue);
	return;
}

try {
	$conn = new pdo('mysql:unix_socket=/cloudsql/caramel-howl-113305:snatch;dbname=snatch', 'root', '');
} catch(PDOException $ex) {
	die(json_encode(
    	array('status' => 'error', 'message' => 'Unable to connect')
    	)
	);
}

$returnValue = array();

$sql = "select count(*) from users where username='" . $username . "'";

$result = $conn->query($sql);

if ($result->fetchColumn() >= 1) {
	$returnValue["status"] = "error";
	$returnValue["message"] = "User already exists";
	echo json_encode($returnValue);
	return;
}

$secure_password = md5($password); // I do this, so that user password cannot be read even by me

$initialScore = "0";
$sql = "insert into users (email, username, password, highscore) values (?,?,?,?)";
$statement = $conn->prepare($sql);

$result = $statement->execute(array($email, $username, $secure_password, $initialScore));
if ($result) {
	$returnValue["status"] = "Success";
	$returnValue["message"] = "User is registered";
	echo json_encode($returnValue);
	return;
}

$conn = null;



/*$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetails($username);

if(!empty($userDetails))
{
	$returnValue["status"] = "error";
	$returnValue["message"] = "User already exists";
	echo json_encode($returnValue);
	return;
}

$secure_password = md5($password); // I do this, so that user password cannot be read even by me

$result = $dao->registerUser($email, $username, $secure_password);

if($result)
{
	$returnValue["status"] = "Success";
	$returnValue["message"] = "User is registered";
	echo json_encode($returnValue);
	return;
}

$dao->closeConnection();*/

?>

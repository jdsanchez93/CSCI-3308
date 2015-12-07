<?php
class MySQLDao {
var $dbhost = null;
var $dbuser = null;
var $dbpass = null;
var $conn = null;
var $dbname = null;
var $result = null;

public function openConnection() {
	try {
    	$conn = new pdo('mysql:unix_socket=/cloudsql/caramel-howl-113305:snatch;dbname=snatch', 'root', '');
    } catch(PDOException $ex) {
    	die(json_encode(
        	array('status' => 'error', 'message' => 'Unable to connect')
        	)
    	);
    }
}

public function getConnection() {
	return $this->conn;
}

public function closeConnection() {
	if ($this->conn != null)
		$this->conn = null;
}

public function getUserDetails($username)
{
	$returnValue = array();
	$returnValue["status"] = "error";
	$returnValue["message"] = "Missing required field";
	echo json_encode($returnValue);
	return $returnValue;
	$sql = "select count(*) from users where username='" . $username . "'";

	$result = $this->conn->query($sql);
	
	if ($result != null && ($result->fetchColumn() >= 1)) {
		$returnValue["exists"] = "yes";
	}
	return $returnValue;
}

public function getUserDetailsWithPassword($username, $userPassword)
{
	$returnValue = array();
	$sql = "select count(*) from users where username='" . $username . "' and password='" .$userPassword . "'";

	$result = $this->conn->query($sql);
	if ($result != null && ($result->fetchColumn() >= 1)) {
	$row = $result->fetch_array(MYSQLI_ASSOC);
		$returnValue["exists"] = "yes";
	}
	return $returnValue;
}

public function registerUser($email, $username, $password)
{
	$initialScore = "0";
	$sql = "insert into users (email, username, password, highscore) values (?,?,?,?)";
	$statement = $this->conn->prepare($sql);

	if (!$statement) {
		throw new Exception($statement->error);
		
	}

	$statement->bindParam("ssss", $email, $username, $password, $initialScore);
	$returnValue = $statement->execute();

	return $returnValue;
}

}
?>

<?php
class MySQLDao {
var $dbhost = null;
var $dbuser = null;
var $dbpass = null;
var $conn = null;
var $dbname = null;
var $result = null;

function __construct() {
$this->dbhost = Conn::$dbhost;
$this->dbuser = Conn::$dbuser;
$this->dbpass = Conn::$dbpass;
$this->dbname = Conn::$dbname;
}

public function openConnection() {
	$this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);
	if (mysqli_connect_errno()) {
		echo new Exception("Could not establish connection with database");
	}
}

public function getConnection() {
return $this->conn;
}

public function closeConnection() {
if ($this->conn != null)
$this->conn->close();
}

public function getUserDetails($username)
{
$returnValue = array();
$sql = "select * from users where username='" . $username . "'";

$result = $this->conn->query($sql);
if ($result != null && (mysqli_num_rows($result) >= 1)) {
$row = $result->fetch_array(MYSQLI_ASSOC);
if (!empty($row)) {
$returnValue = $row;
}
}
return $returnValue;
}

public function getUserDetailsWithPassword($username, $userPassword)
{
$returnValue = array();
$sql = "select username from users where username='" . $username . "' and password='" .$userPassword . "'";

$result = $this->conn->query($sql);
if ($result != null && (mysqli_num_rows($result) >= 1)) {
$row = $result->fetch_array(MYSQLI_ASSOC);
if (!empty($row)) {
$returnValue = $row;
}
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

	$statement->bind_param("ssss", $email, $username, $password, $initialScore);
	$returnValue = $statement->execute();

	return $returnValue;
}

public function getHighScores() {
	$sql = "select username, highscore from users";
	$result = $this->conn->query($sql);
	echo "<table style='width:100%'><tr><td>Username</td><tr>Highscore</tr>";
	if ($result->num_rows >0) {
		//output data of each row
		while($row = $result->fetch_assoc()) {
			echo "<tr><td>" . $row["username"] . "</td><td>" . $row["highscore"] . "</td></tr>";
		}
	} else {
		echo "No highscores"
	}
}

}
?>

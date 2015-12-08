<title>Snatch N' Grab</title>
<h1>Snatch N' Grab</h1>

<?php
	//use google\appengine\api\users\User;
	//use google\appengine\api\users\UserService;

	//$user = UserService::getCurrentUser();

	$conn = null;

	if (isset($_SERVER['SERVER_SOFTWARE']) && 
		strpos($_SERVER['SERVER_SOFTWARE'],'Google App Engine') !== false) {
	    // Connect from App Engine.
	    //$conn = new mysqli(null, "root", "", "snatch", null, "cloudsql/caramel-howl-113305:snatch");
	    try {
	    	$conn = new pdo('mysql:unix_socket=/cloudsql/caramel-howl-113305:snatch;dbname=snatch', 'root', '');
	    } catch(PDOException $ex) {
	    	die(json_encode(
            	array('outcome' => false, 'message' => 'Unable to connect')
            	)
        	);
	    }
  	} else {
    	// Connect from a development environment.
    	//$conn = new mysqli("173.194.235.192", "joseph", "admin", "snatch");
    	try {
    		$conn = new pdo('mysql:host=173.194.235.192;dbname=snatch', 'joseph', 'admin');
    	} catch(PDOException $ex) {
	    	die(json_encode(
            	array('outcome' => false, 'message' => 'Unable to connect')
            	)
        	);
	    }
 	}

 	echo "<table style='width:25%'><tr><td>Username</td><td>Highscore</td></tr>";
 	foreach($conn->query('SELECT * from users') as $row) {
            echo "<tr><td>" . $row["username"] . "</td><td>" . $row["highscore"] . "</td></tr>";
    }

    $conn = null;


    /*if (mysqli_connect_errno()) {
    	echo new Exception("Could not establish connection with database");
    }

    $sql = "select username, highscore from users";

    if ($result->num_rows >0) {
		//output data of each row
		while($row = $result->fetch_assoc()) {
			echo $row["username"] . " " . $row["highscore"] . "<br>";
		}
	} else {
		echo "No highscores";
	}

    if ($conn != null) {
    	$conn->close();
    }*/
?>

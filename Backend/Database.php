<?php
require_once("APIException.php");
require_once("config.php");
class Database {
    private static $instance = null;
    private $connection;
    private $publisher;

    public static function getInstance() {
        if (!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    private function __construct() {
        $this->publisher = $GLOBALS["config"]["publisher"]["publisher_id"];
        $host = $GLOBALS["config"]["database"]["host"];
		$user = $GLOBALS["config"]["database"]["user"];
		$password = $GLOBALS["config"]["database"]["password"];
		$name = $GLOBALS["config"]["database"]["name"];

        try {
            $this->connection = new PDO("mysql:host=$host;dbname=$name", $user, $password);
            $this->connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            error_log($e->getTraceAsString());
            throw new ApiException(500, "server_error", "Could not connect to database.");
        }
    }

    public function __destruct() {
        $this->connection = null;
    }

    // ======================================================================================
	// MAIN DATABASE FUNCTIONS
	// ======================================================================================

    /** Runs a given SQL query (e.g. insert, update, etc.)
     * @param string $query SQL query
     * @param array $params Bound parameters for each query
     * @return PDOStatement PDO Statement object
     * @throws ApiException
     */
    public function executeQuery($query = "", $params = []) {
        try {
            $stmt = $this->connection->prepare($query);
    
            if ($stmt === false) {
                throw new ApiException(500, "server_error", "Error while trying to execute a database query.");
            }
            
            if (!$stmt->execute($params)) {
                throw new ApiException(500, "server_error", "Error while trying to execute a database query.");
            }
            
        } catch (PDOException $e) {
            error_log($e->getTraceAsString());
            throw new ApiException(500, "server_error", "Error while trying to execute a database query.");
        }

        return $stmt;
    }

    /** Runs a given select query
     * @param string $query SQL query
     * @param array $params Bound parameters for each query
     * @return array Associative array with select results
     * @throws ApiException
     */
    public function select($query = "", $params = []) {
        $stmt = $this->executeQuery($query, $params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /** Returns the last auto generated ID created by a new insert
     * @return integer Last generated ID
     */
    public function getLastGeneratedID() {
        $id = $this->connection->lastInsertId();

        if ($id === false) {
            throw new ApiException(500, "server_error", "Error while trying to execute a database query.");
        }

        return intval($id);
    }

    // ======================================================================================
    // USER FUNCTIONS
    // ======================================================================================

    private function generateAPIKey() {
      $invalid = true;
      while ($invalid) {
	$invalid = false;
	$key = bin2hex(random_bytes(32));
	$sub = substr($key,0,32);
	$closematch = $this->connection->prepare("some database shit. '$sub'");
	foreach ($closematch as $match) {
	  if (hash_equals($match, $key)) {
	    $invalid = true;
	    break;
	  }
	}
      }
      return $key;
    }

    // Registers a user. Adds their details to the database.
    // TODO: No idea how the db implimentation works. SO stuff should change
    // 	will mark as todo where needed.
    public function registerUser($email, $password) {
        // Check if a user exists
        // TODO: Replace Query
        $query = "SELECT THE EMAIL";
        $results = $this->select($query, "s", [$email]);

        // if the email exists then throw a error.
        if ($results[0]["email"] == $email) {
            throw new APIException(454, "user_error", "The email you provided already has a accociated account. Please login.");
        }

        // Register the user. TODO: Change this according to the database.
        $query = "INSERT SOME THING IDFK";
        // Hashing and salting.
        $password = password_hash($password, PASSWORD_DEFAULT);
	$apiKey = $this->generateAPIKey();
        // No need to store result.
        $this->executeQuery($query, "sss", [$email, $password, $apiKey]);
	return $apiKey;
    }

    public function changeUserPassword($newpassword, $apiKey) {
        // Check if a user exists
        // TODO: Replace Query
        $query = "SELECT THE apiKey";
        $results = $this->select($query, "s", [$apiKey]);

        // if the email exists then throw a error.
        if ($results[0]["apiKey"] == $apiKey) {
	    // Register the user. TODO: Change this according to the database.
	    $query = "Update SOME THING IDFK";
	    // Hashing and salting.
	    $password = password_hash($newpassword, PASSWORD_DEFAULT);

	    // TODO Check  paramter order
	    $this->executeQuery($query, "ss", [$password, $apiKey]);

	    return $apiKey;
	} else {
            throw new APIException(454, "user_error", "This user does not exist. Please login or re-log.");
	}

    }

    public function changeUserEmail($newEmail, $apiKey) {
        $query = "SELECT THE apiKey";
        $results = $this->select($query, "s", [$apiKey]);

        // if the email exists then throw a error.
        if ($results[0]["apiKey"] == $apiKey) {
	    // Register the user. TODO: Change this according to the database.
	    $query = "update SOME THING IDFK";
	    // TODO Check parameter order
	    $this->executeQuery($query, "ss", [$newEmail, $apiKey]);
	    return $apiKey;
	} else {
            throw new APIException(454, "user_error", "This user does not exist. Please login or re-log.");
	}
    }

    public function changeUserProfilePicture($picture, $apiKey) {
        $query = "SELECT THE apiKey";
        $results = $this->select($query, "s", [$apiKey]);

        // if the email exists then throw a error.
        if ($results[0]["apiKey"] == $apiKey) {
	    // Register the user. TODO: Change this according to the database.
	    $query = "update SOME THING IDFK";
	    // TODO Check parameter order
	    $this->executeQuery($query, "ss", [$picture, $apiKey]);
	    return $apiKey;
	} else {
            throw new APIException(454, "user_error", "This user does not exist. Please login or re-log.");
	}
    }

    public function loginUser($email, $password) {
        // Check if a user exists
        // TODO: Replace Query
        $query = "SELECT THE EMAIL";
        $results = $this->select($query, "s", [$email]);

        // Hashing and salting.
        // TODO: password field might be something else
        if (password_verify($password, $results["password"])) {
            //TODO add cookie stuff probably
            return $results["apiKey"];
            // No need to store result.
        } else {
            return false;
        }
    }

    public function authorizeUser($key) {
        $query = "SELECT * FROM users WHERE apiKey = ?";
        $result = $this->select($query, [$key]);
        if ($result == []) {
            return false;
        } else {
            return true;
        }
    }

    // ======================================================================================
    // PLAYER FUNCTIONS
    // ======================================================================================

    function insertPlayer($data) {
        foreach ($data as $object) {
            $birthAddr = $object["birthAddr"];

            $query = "INSERT INTO locations (city, country, country_code) VALUES (?, ?, ?)";
            $locationStmt = $this->executeQuery($query, [$birthAddr["city"], $birthAddr["country"], $birthAddr["countryCode"]]);
            $locationId = $this->getLastGeneratedID();

            $query = "INSERT INTO addresses (location_id, street_number, street, postal_code, country) VALUES (?, ?, ?, ?, ?)";
            $addressStmt = $this->executeQuery($query, [$locationId, $birthAddr["streetNo"], $birthAddr["street"], $birthAddr["postalCode"], $birthAddr["country"]]);
    
            $query = "INSERT INTO persons (person_key, publisher_id, gender, birth_date, birth_location_id) VALUES (?, ?, ?, ?, ?)";
            $personStmt = $this->executeQuery($query, [$object["personKey"], $this->publisher, $object["gender"], $object["DOB"], $locationId]);
            $personId = $this->getLastGeneratedID();

            $query = "INSERT INTO display_names (language, entity_type, entity_id, full_name, first_name, last_name) VALUES (?, ?, ?, ?, ?, ?)";
            $fullName = $object["firstName"] . " " . $object["lastName"];
            $displayNameStmt = $this->executeQuery($query, ["en-US", "persons", $personId, $fullName, $object["firstName"], $object["lastName"]]);
        }
    }

    function getPlayers() {
        $query = "SELECT * FROM player_data";
        $response = $this->select($query);
        return $response;
    }

    // ======================================================================================
    // TEAM FUNCTIONS
    // ======================================================================================
}

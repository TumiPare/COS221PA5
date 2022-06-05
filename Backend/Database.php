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

            !$stmt->execute($params);
            
        } catch (PDOException $e) {
            error_log($e->getMessage());
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

    public function getErrorCode($stmt) {
        return $stmt->errorInfo()[1];
    }

    // ======================================================================================
    // USER FUNCTIONS
    // ======================================================================================

    /**
     * Register a new user/users to the the database
     * 
     * @param $data Associative array with all the user objects
     * @return array Associative array with all the newly registered user info
     */
    function addUser($data) {
        $response = [];

        foreach ($data as $user) {

            if (count($data) == 1) {
                if (!$this->validateEmail($user["email"])) {
                    throw new ApiException(400, "invalid_email", "Provided email is invalid.");
                }

                if (!$this->validatePassword($user["password"])) {
                    throw new ApiException(400, "invalid_password", "Provided password is invalid.");
                }
            }

            $query = "INSERT INTO users (email, username, password) VALUES (?, ?, ?)";
            $password = password_hash($user["password"], PASSWORD_DEFAULT);
            $stmt = $this->executeQuery($query, [$user["email"], $user["username"], $password]);
            
            if ($this->getErrorCode($stmt) == 1062) {
                if (count($data) == 1) {
                    throw new ApiException(454, "email_taken", "The email provided already has an account associated with it. Please log in.");
                } else {
                    continue;
                }
            }
            
            $query = "UPDATE users SET apiKey = ? WHERE email = ?";
            
            while (true) {
                $apiKey = $this->generateAPIKey();
                $stmt = $this->executeQuery($query, [$apiKey, $user["email"]]);

                if ($this->getErrorCode($stmt) == NULL) {
                    break;
                }
            }

            array_push($response, ["apiKey" => $apiKey, "username" => $user["username"], "email" => $user["email"]]);
        }

        return $response;
    }

    public function loginUser($data) {
        $query = "SELECT * FROM users WHERE email = ?";
        $result = $this->select($query, [$data[0]["email"]]);

        if ($result == []) {
            throw new ApiException(401, "invalid_email", "Account with this email does not exist.");
        }

        $result = $result[0];

        if (!password_verify($data[0]["password"], $result["password"])) {
            throw new ApiException(401, "invalid_password", "Provided password is invalid");
        }

        return array(["apiKey" => $result["apiKey"], "username" => $result["username"], "email" => $result["email"]]);
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

    /** Used to validate wether a incoming API request is valid
     * @param $key User's API Key
     * @return boolean
     */
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

    function addPlayers($data) {
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


    // ======================================================================================
    // SMALL UTILITY FUNCTIONS
    // ======================================================================================

    private function generateAPIKey() {
        $alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        $key = "";

        for ($i = 0; $i < 32; $i++) {
            $index = random_int(0, 61);
            $key .= substr($alphabet, $index, 1);
        }

        return $key;
    }


    function validateEmail($email) {
        $regex = '/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/';
        return (preg_match($regex, $email) == false) ? false : true;
    }

    function validatePassword($password) {
        $regex = "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/";
        return (preg_match($regex, $password) == false) ? false : true;
    }

}

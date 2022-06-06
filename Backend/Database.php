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

    /**
     * Returns the SQL error code for a specific statement
     * 
     * @param $stmt A PDOStatement
     * @return integer|NULL Returns NULL id no error occurred
     */
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
            $query = "INSERT INTO users (email, username, password) VALUES (?, ?, ?)";
            $password = password_hash($user["password"], PASSWORD_DEFAULT);
            $stmt = $this->executeQuery($query, [$user["email"], $user["username"], $password]);
            
            if ($this->getErrorCode($stmt) == 1062) {
                if (count($data) == 1) {
                    throw new ApiException(200, "email_taken", "The account with provided email is already taken.");
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
        $result = $this->select($query, [$data["email"]]);

        if ($result == []) {
            throw new ApiException(200, "invalid_email", "Account with this email does not exist.");
        }

        $result = $result[0];

        if (!password_verify($data["password"], $result["password"])) {
            throw new ApiException(200, "invalid_password", "Provided password is invalid.");
        }

        return array(["apiKey" => $result["apiKey"], "username" => $result["username"], "email" => $result["email"]]);
    }

    public function setUser($data, $apiKey) {
        $query = "SELECT * FROM users WHERE apiKey = ?";
        $result = $this->select($query, [$apiKey])[0];

        if ($data["username"] != NULL) {
            $result["username"] = $data["username"];
        }

        if ($data["email"] != NULL) {
            $result["email"] = $data["email"];
        }

        if ($data["password"] != NULL) {
            $result["password"] = password_hash($data["password"], PASSWORD_DEFAULT);
        }

        $query = "UPDATE users SET username = ?, email = ?, password = ? WHERE apiKey = ?";
        $stmt = $this->executeQuery($query, [$result["username"], $result["email"], $result["password"], $apiKey]);

        return array(["apiKey" => $apiKey, "username" => $result["username"], "email" => $result["email"]]);
    }

    public function deleteUser($data) {
        $query = "DELETE FROM users WHERE apiKey = ?";
        $stmt = $this->executeQuery($query, [$data["apiKey"]]);

        if ($stmt->rowCount() === 0) {
            throw new ApiException(200, "user_not_found", "No user matching provided API key was found.");
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

            if ($object["image"] == NULL) {
                continue;
            }
            
            $query = "INSERT INTO media (b64_image, publisher_id) VALUES (?, ?)";
            $mediaStmt = $this->executeQuery($query, [$object["image"], $this->publisher]);
            $mediaId = $this->getLastGeneratedID();

            $query = "INSERT INTO persons_media (person_id, media_id) VALUES (?, ?)";
            $mediaPersonStmt = $this->executeQuery($query, [$personId, $mediaId]);
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
    
}

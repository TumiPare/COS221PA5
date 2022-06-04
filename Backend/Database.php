<?php
require_once "APIException.php";
class Database {
    private static $instance = null;
    private $connection;

    public static function getInstance() {
        if (!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    private function __construct() {
        $host = $GLOBALS["config"]["database"]["host"];
		$user = $GLOBALS["config"]["database"]["user"];
		$password = $GLOBALS["config"]["database"]["password"];
		$name = $GLOBALS["config"]["database"]["name"];
		$port = $GLOBALS["config"]["database"]["port"];

        $this->connection = new mysqli($host, $user, $password, $name, $port);

        if ($this->connection->connect_error) {
            throw new ApiException(500, "server_error", "Could not connect to database");
        }
    }

    private function __destruct() {
        $this->connection->close();
    }

    // ======================================================================================
	// MAIN DATABASE FUNCTIONS
	// ======================================================================================

    /** Runs a given SQL query (insert OR update)
     * Will throw an API exception if the query execution failed
     * @param $query: the SQL query
     * @param $types: string of sql types, eg: 'sdss'
     * @param $params: Array of parameters passed for the prepared statement
     * @return the MySQLi statement
     */
    public function executeQuery($query = "", $types = "", $params = []) {
        $stmt = self::$connection->prepare($query);

        if ($stmt === false) {
            throw new ApiException(500, "server_error", "We had a problem with our server. Try again later.");
        }

        if (count($params) !== 0 && $stmt->bind_param($types, ...$params) === false) {
            throw new ApiException(500, "server_error", "We had a problem with our server. Try again later.");
        }

        $stmt->execute();

        return $stmt;
    }

    /** Runs a given select query
     * Will throw an API exception if the query execution failed
     * @param $query: the SQL query
     * @param $types: string of sql types, eg: 'sdss'
     * @param $params: Array of parameters passed for the prepared statement
     * @return associative array of the select results
     */
    public function select($query = "", $types = "", $params = []) {
        try {
            $stmt = $this->executeQuery($query, $types, $params);
            $result = $stmt->get_result();
            if ($result == false) {
                throw new ApiException(500, "server_error", "We had a problem with our server. Try again later.");
            }
            $stmt->close();
            return $result->fetch_all(MYSQLI_ASSOC);
        } catch (ApiException $e) {
            throw $e;
        }
    }


    // ======================================================================================
    // USER FUNCTIONS
    // ======================================================================================
    
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

        // No need to store result.
        $this->executeQuery($query, "ss", [$email, $password]);
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
            return true;
            // No need to store result.
        } else {
            return false;
        }
    }

    // ======================================================================================
    // PLAYER FUNCTIONS
    // ======================================================================================

    

    // ======================================================================================
    // TEAM FUNCTIONS
    // ======================================================================================
}

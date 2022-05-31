<?php
  require_once "APIException.php";
  class Database {
    private static $instance = null;
    private $server;
    private $username;
    private $password;
    private $connection;

    public static function getInstance() {
      if(!self::$instance) {
	self::$instance = new Database();
      }
      return self::$instance;
    }

    private function __construct() {
      $this->server = "178.128.33.26";
      $this->username = "blue_church_member";
      $this->password = "blue_church";

      $this->connection = new mysqli($this->server, $this->username, $this->password);

      if ($this->connection->connect_error) {
	die("Connection failed: " . $this->connection->connect_error);
      }
      $this->connection->select_db("waitless"); // this maay change
    }

    private function __destruct() {
      $this->connection->close();
    }


    // Runs any given query.
    // 	Make a seperate fucntion for each type of SQL statemtn that you want
    // 	And then use this function in that statement. This makes code
    // 	Easier to read from the API File.
    //
    // 	Uses a  prepared statement.
    //  Query : SQL string
    // 	Types : string of sql types, eg: "sdss".
    //  Parameters: The parameters that you want to use for the statement.
    // 		Must be a array
    //  Returns a accociative array of the results
    public function query($query = "", $types = "", $params = []) {
      try {
	$stmt = $this->executeStmt($query, $types, $params);

	$result = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
	$stmt->close();

	return $result;
      } catch (ApiException $e) {
	throw $e;
      }
    }

    // Part of query. IDk how the fuck this works. Ask armand
    public function executeStmt($query = "", $types = "", $params = []) {
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

    // Registers a user. Adds their details to the database.
    // TODO: No idea how the db implimentation works. SO stuff should change
    // 	will mark as todo where needed.
    public function registerUser($email, $password) {
      // Check if a user exists
      // TODO: Replace Query
      $query = "SELECT THE EMAIL";
      try {
	$results = $this->query($query, "s", [$email]);
      } catch (APIException $e) {
	throw $e;
      }

      // if the email exists then throw a error.
      if ($results[0]["email"] == $email) {
	throw new APIException(454, "user_error", "The email you provided already has a accociated account. Please login.");
      }

      // Register the user. TODO: Change this according to the database.
      $query = "INSERT SOME THING IDFK";
      // Hashing and salting.
      $password = password_hash($password, PASSWORD_DEFAULT);

      // No need to store result.
      try {
	$this->query($query, "ss", [$email, $password]);
      } catch (APIException $e) {
	throw $e;
      }
    }

    public function loginUser($email, $password) {
      // Check if a user exists
      // TODO: Replace Query
      $query = "SELECT THE EMAIL";
      try {
	$results = $this->query($query, "s", [$email]);
      } catch (APIException $e) {
	throw $e;
      }

      // Hashing and salting.
      // TODO: password field might be something else
      if (password_verify($password,$results["password"])) {
	//TODO add cookie stuff probably
	return true;
      // No need to store result.
      } else {
	return false;
      }
    }
  }
?>

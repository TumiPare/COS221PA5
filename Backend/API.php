<?php
  require_once "Database.php";
  class API {
    // Stores the response. Should be some kind of JSON
    private $response;
    // Stores the request made by a call. This will be a accociative array.
    private $request;
    // Database connection.
    private $database;

    private function __construct() {
      $this->response = "";
      $this->request = "";
      $this->database = Database::getInstance();
    }

    // Quickly validates JSON.
    // Returns True if JSON is valid
    // Returns False if JSON is not valid
    private function validateJSON($string) {
      json_decode($string);
      if (json_last_error() == JSON_ERROR_NONE) {
	return true;
      }
      return false;
    }

    // Checks if a given email is valid or not.
    // 	Returns false if it is not.
    // 	Returns the given emial if the email is valid.
    private function validateEmail($email) {
      if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
	return false;
      } else {
	return $email;
      }
    }

    // Checks if a password matches the requirements that we specify
    // 	Returns false if the password is not valid
    // 	Returns the password if the password is valid.
    private function validatePassword($password) {
      $reg = '/^.*(?=.{8,})(?=.*\d)(?=.*[!#$%&?@ "]).*$/';

      if (!preg_match($reg, $password)) {
	return false;
      } else {
	return $password;
      }
    }

    // Registers a user to the database.
    // Requires:
    // 	- type : "register"
    // 	- email
    //  - password
    private function RegisterUser() {
      $email = $this->validateEmail($this->request["email"]);
      $password = $this->validatePassword($this->request["password"]);

      if ($email !== false && $password !== false) {
	// Try for APIException
	try {
	  $this->database->registerUser($email, $password);
	} catch (APIException $e) {
	  throw $e;
	}
	// dealing with email exceptions and stuff.
      } else if ($email === false) {
	throw new APIException(400, "user_error", "The provided email is invalid. Please provide a valid email address.");
      } else if ($password === false) {
	throw new APIException(400, "user_error", "The provided password did not meet the required criteria.");
      }
      $this->response["data"] = "User successfully created.";
      return true;
    }

    // Checks that provided details are valid and then
    // 	logs-in user if they are.
    private function LoginUser() {
      $email = $this->validateEmail($this->request["email"]);
      $password = $this->validatePassword($this->request["password"]);

      if ($email !== false && $password !== false) {
	// Try for APIException
	try {
	  $this->database->LoginUser($email, $password);
	} catch (APIException $e) {
	  throw $e;
	}
	// dealing with email exceptions and stuff.
      } else if ($email === false) {
	throw new APIException(400, "user_error", "The login details that were provided are incorrect.");
      } else if ($password === false) {
	throw new APIException(400, "user_error", "The login details that were provided are incorrect.");
      }
      $this->response["data"] = "User successfully logged in.";
      return true;
    }

    // handles requests based on their types.
    public function handleRequest() {
      // get the request and just check that it has valid JSON.
      $request = file_get_contents('php://input');
      if ($this->validateJSON($request)) {
	$this->request = json_decode($request, true);
      } else {
	// here we should make some kinda error but im not gonna do that yet.
	return false;
      }

      // Dealling with different types of requests.
      try {
	if ($this->request["type"] == "register") {
	  $this->RegisterUser();
	} else if ($this->request["type"] == "login") {
	  $this->LoginUser();
	}
	// creates the last part of the response, You should make the main
	//  parts of the response in the body of the function that you
	//  excecute
	$this->response["status"] = "success";
	$this->response["timestamp"] = time();

      } catch (APIException $e) {
	$this->response = $e->makeJsonResponse();
      }
    }
  }
?>

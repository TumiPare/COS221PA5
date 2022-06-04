<?php
require_once("Database.php");
require_once("APIException.php");
class API {
    // Stores the response to be sent. This will be a associative array.
    private $response;
    // Stores the request made by a call. This will be a associative array.
    private $request;
    // Database connection.
    private $database;

    public function __construct() {
        $this->response = "";
        $this->request = "";
        $this->database = Database::getInstance();
    }

    // ======================================================================================
    // UTILITY FUNCTIONS
    // ======================================================================================

    private function validateJSON($string) {
        json_decode($string);
        if (json_last_error() == JSON_ERROR_NONE) {
            return true;
        }
        return false;
    }

    function sendResponse() {
        header("200 OK");
        header("Content-Type: application/json");

        echo (json_encode([
            "status" => "success",
            "timestamp" => time(),
            "data" => $this->response
        ]));
    }

    // ======================================================================================
    // DANIEL's FUNCTIONS
    // ======================================================================================

    // Checks if a given email is valid or not.
    // 	Returns false if it is not.
    // 	Returns the given email if the email is valid.
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
            $this->database->registerUser($email, $password);
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
            $this->database->LoginUser($email, $password);
            // dealing with email exceptions and stuff.
        } else if ($email === false) {
            throw new APIException(400, "user_error", "The login details that were provided are incorrect.");
        } else if ($password === false) {
            throw new APIException(400, "user_error", "The login details that were provided are incorrect.");
        }
        $this->response["data"] = "User successfully logged in.";
        return true;
    }

    // ======================================================================================
    // REQUEST HANDLER FUNCTIONS
    // ======================================================================================

    public function handleRequest() {
        if ($_SERVER["REQUEST_METHOD"] !== "POST") {
            throw new ApiException(400, "wrong_request_method", "Only POST requests are allowed.");
        }

        // Get request from user and validate the JSON request
        $request = file_get_contents('php://input');
        if ($this->validateJSON($request)) {
            $this->request = json_decode($request, true);
        } else {
            throw new ApiException(400, "malformed_request", "JSON request could not be decoded, make sure syntax is correct.");
        }

        switch ($this->request["type"]) {
            case "player":
                $this->handlePlayer();
                break;
            case "team":
                $this->handleTeam();
                break;
            case "user":
                $this->handleUser();
                break;
        }

        $this->sendResponse();
    }

    function handlePlayer() {
        if (isset($req["add"])) {
            $toSet = $req["set"];
            $email = "";
            if (!isset($toSet["email"]) || !isset($toSet["password"])) {
                throw new ApiException(400, "invalid_user_add", "The request to add a new user was of invalid format");
            }
        } else if (isset($req["get"])) {
        }
    }

    function handleUser() {
        if ($this->request["type"] == "register") {
            $this->RegisterUser();
        } else if ($this->request["type"] == "login") {
            $this->LoginUser();
        }
    }

    function handleTeam() {
    }
}





// API instance to handle all incoming requests
$api = new API();
try {
    $api->handleRequest();
} catch (ApiException $e) {
    error_log($e->getTraceAsString());
    $e->sendJsonResponse();
}

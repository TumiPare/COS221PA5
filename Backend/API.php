<?php
require_once("Database.php");
require_once("APIException.php");
class API {
    // Stores the response to be sent. This will be an associative array.
    // Example: $this->response = $this->database->getPlayers();
    private $response;
    // Stores the request made by a user request. This will be an associative array.
    private $request;
    // Database connection.
    private $database;

    public function __construct() {
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

        if (!is_array($this->response)) {
            echo (json_encode([
                "status" => "success",
                "timestamp" => time()
            ]));
        } else {
            echo (json_encode([
                "status" => "success",
                "timestamp" => time(),
                "data" => $this->response
            ]));
        }
    }

    /** Validates all the required fields in a JSON request
     * Will throw an API exception if a required field is missing
     * @param $data: A associative array containing the request data
     * @param $fields: An associative array with all the required fields
     */
    function validateRequiredFields($data, $fields) {
        foreach ($fields as $field) {
            $fieldFound = false;

            foreach ($data as $key => $value) {
                if ($key == $field) {
                    $fieldFound = true;
                    break;
                }
            }
                
            if (!$fieldFound) {
                throw new ApiException(400, "required_field_missing", "A required field is missing from one of the objects.");
            }
        }
    }

    /** Validates all the optional fields in a JSON request
     * Will set any missing optional fields to NULL
     * @param $data: A associative array containing the request data
     * @param $fields: An associative array with all the optional fields
     */
    function validateOptionalFields(&$data, $fields) {
        foreach ($fields as $field) {
            $fieldFound = false;

            foreach ($data as $key => $value) {
                if ($key == $field) {
                    $fieldFound = true;
                    break;
                }
            }

            if (!$fieldFound) {
                $data[$field] = "NULL";
            }
        }
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

        // Validate user JSON request
        $request = file_get_contents('php://input');
        if ($this->validateJSON($request)) {
            $this->request = json_decode($request, true);
        } else {
            throw new ApiException(400, "malformed_request", "JSON request could not be decoded, make sure syntax is correct.");
        }

        if (!array_key_exists("type", $this->request)) {
            throw new ApiException(400, "invalid_type", "Type is not specified.");
        }

        if (!array_key_exists("operation", $this->request)) {
            throw new ApiException(400, "invalid_operation", "Operation is not specified.");
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
            default:
                throw new ApiException(400, "invalid_type", "The specified type is not valid.");
                break;
        }

        // Response will be sent after whichever query has executed successfully
        $this->sendResponse();
    }

    function handlePlayer() {
        if ($this->request["operation"] == "set") {
            
        } else if ($this->request["operation"] == "get") {
           $this->response = $this->database->getPlayers();
        } else if ($this->request["operation"] == "add") {
            $data = $this->request["data"];
            $requiredPersonInfo = ["firstName", "lastName", "gender", "DOB", "personKey", "birthAddr"];
            $requiredAddressInfo = ["streetNo", "street", "city", "postalCode", "country", "countryCode"];
            
            foreach ($data as $object) {
                $this->validateRequiredFields($object, $requiredPersonInfo);
                $this->validateRequiredFields($object["birthAddr"], $requiredAddressInfo);
            }
            
            $this->database->insertPlayer($data);
        } else {
            throw new ApiException(400, "invalid_operation", "Invalid operation, only set, get and add is allowed.");
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
<?php
require_once("Database.php");
require_once("APIException.php");
class API
{
    // Stores the response to be sent. This will be an associative array.
    // Example: $this->response = $this->database->getPlayers();
    private $response;
    // Stores the request made by a user request. This will be an associative array.
    private $request;
    // Database connection.
    private $database;

    public function __construct()
    {
        $this->database = Database::getInstance();
    }

    // ======================================================================================
    // UTILITY FUNCTIONS
    // ======================================================================================

    private function validateJSON($string)
    {
        json_decode($string);
        if (json_last_error() == JSON_ERROR_NONE) {
            return true;
        }
        return false;
    }

    private function authorizeRequest()
    {
        if (!array_key_exists("apiKey", $this->request)) {
            throw new ApiException(401, "unauthorized", "User key has to be provided.");
        }

        $authorized = $this->database->authorizeUser($this->request["apiKey"]);

        if (!$authorized) {
            throw new ApiException(401, "unauthorized", "User key is invalid.");
        }
    }

    function sendResponse()
    {
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
     * @param $data A associative array containing the request data
     * @param $fields An associative array with all the required fields
     */
    function validateRequiredFields($data, $fields)
    {
        foreach ($fields as $field) {
            $fieldFound = false;

            foreach ($data as $key => $value) {
                if ($key == $field) {
                    $fieldFound = true;
                    break;
                }
            }

            if (!$fieldFound) {
                throw new ApiException(400, "required_field_missing", "The $field field is missing from one of the objects.");
            }
        }
    }

    /** Validates all the optional fields in a JSON request
     * Will set any missing optional fields to NULL
     * @param $data A associative array containing the request data
     * @param $fields An associative array with all the optional fields
     */
    function validateOptionalFields(&$data, $fields)
    {
        foreach ($fields as $field) {
            $fieldFound = false;

            foreach ($data as $key => $value) {
                if ($key == $field) {
                    $fieldFound = true;
                    break;
                }
            }

            if (!$fieldFound) {
                $data[$field] = NULL;
            }
        }
    }

    // ======================================================================================
    // REQUEST HANDLER FUNCTIONS
    // ======================================================================================

    public function handleRequest()
    {
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

    private function handlePlayer()
    {
        $this->authorizeRequest();

        if ($this->request["operation"] == "set") {
        } else if ($this->request["operation"] == "get") {
            $this->response = $this->database->getPlayers();
        } else if ($this->request["operation"] == "add") {
            $this->addPlayers($this->request["data"]);
        } else {
            throw new ApiException(400, "invalid_operation", "Invalid operation, only set, get and add is allowed.");
        }
    }

    private function handleUser()
    {
        if ($this->request["operation"] == "add") {
            $this->addUser($this->request["data"]);
        } else if ($this->request["operation"] == "set") {
            $this->authorizeRequest();
            $this->setUser($this->request);
        } else if ($this->request["operation"] == "login") {
            $this->loginUser($this->request["data"]);
        }
    }

    private function handleTeam()
    {
    }


    // ======================================================================================
    // OPERATION FUNCTIONS
    // ======================================================================================

    // ==================PLAYERS==================
    function addPlayers($data)
    {
        $requiredPersonInfo = ["firstName", "lastName", "gender", "DOB", "personKey", "birthAddr"];
        $requiredAddressInfo = ["streetNo", "street", "city", "postalCode", "country", "countryCode"];

        foreach ($data as $object) {
            $this->validateRequiredFields($object, $requiredPersonInfo);
            $this->validateRequiredFields($object["birthAddr"], $requiredAddressInfo);
        }

        $this->database->addPlayers($data);
    }


    // ===================USERS===================
    function addUser($data)
    {
        $requiredUserInfo = ["username", "email", "password"];

        foreach ($data as $user) {
            $this->validateRequiredFields($user, $requiredUserInfo);

            if (count($data) == 1) {
                if (!$this->validateEmail($user["email"])) {
                    throw new ApiException(400, "invalid_email", "Provided email is invalid.");
                }

                if (!$this->validatePassword($user["password"])) {
                    throw new ApiException(400, "invalid_password", "Provided password is invalid.");
                }
            }
        }

        $this->response = $this->database->addUser($this->request["data"]);
    }

    function loginUser($data)
    {
        $requiredUserInfo = ["email", "password"];
        $this->validateRequiredFields($data[0], $requiredUserInfo);
        $this->response = $this->database->loginUser($data[0]);
    }

    function setUser($data) {
        $user = $data["data"][0];
        $optionalUserInfo = ["username", "email", "password"];
        $this->validateOptionalFields($user, $optionalUserInfo);

        if ($user["username"] == NULL && $user["password"] == NULL && $user["email"] == NULL) {
            throw new ApiException(400, "malformed_request", "New username, email, and password is missing.");
        }

        if ($user["email"] != NULL) {
            if (!$this->validateEmail($user["email"])) {
                throw new ApiException(400, "invalid_email", "Provided email is invalid.");
            }
        }

        if ($user["password"] != NULL) {
            if (!$this->validatePassword($user["password"])) {
                throw new ApiException(400, "invalid_password", "Provided password is invalid.");
            }
        }
        
        $this->response = $this->database->setUser($user, $data["apiKey"]);
    }

    function validateEmail($email)
    {
        $regex = '/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/';
        return (preg_match($regex, $email) == false) ? false : true;
    }

    function validatePassword($password)
    {
        $regex = "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/";
        return (preg_match($regex, $password) == false) ? false : true;
    }
}

// ======================================================================================
// API INSTANCE TO HANDLE INCOMING REQUESTS
// ======================================================================================


// header("Access-Control-Allow-Origin: *");
$ownOrigin = $_SERVER['HTTP_OUR_OWN_ORIGIN'];
header("Access-Control-Allow-Origin: $ownOrigin");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, DELETE, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, OUR-OWN-ORIGIN");

if ($_SERVER['REQUEST_METHOD'] !== 'OPTIONS') {    
    $api = new API();
    try {
        $api->handleRequest();
    } catch (ApiException $e) {
        error_log($e->getTraceAsString());
        $e->sendJsonResponse();
    }
}
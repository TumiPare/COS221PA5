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

    private function authorizeRequest() {
        if (!array_key_exists("apiKey", $this->request)) {
            throw new ApiException(200, "unauthorized", "User key has to be provided.");
        }

        $authorized = $this->database->authorizeUser($this->request["apiKey"]);

        if (!$authorized) {
            throw new ApiException(200, "unauthorized", "User key is invalid.");
        }
    }

    function sendResponse() {
        header("HTTP/1.1 200 OK");
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
                throw new ApiException(200, "required_field_missing", "The $field field is missing from one of the objects.");
            }
        }
    }

    /** Validates all the optional fields in a JSON request
     * Will set any missing optional fields to NULL
     * @param $data A associative array containing the request data
     * @param $fields An associative array with all the optional fields
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
                $data[$field] = NULL;
            }
        }
    }

    function validateDataField() {
        if (!array_key_exists("data", $this->request)) {
            throw new ApiException(200, "data_missing", "The data field is missing.");
        }
    }

    // ======================================================================================
    // REQUEST HANDLER FUNCTIONS
    // ======================================================================================

    public function handleRequest() {
        if ($_SERVER["REQUEST_METHOD"] !== "POST") {
            throw new ApiException(200, "wrong_request_method", "Only POST requests are allowed.");
        }

        // Validate user JSON request
        $request = file_get_contents('php://input');
        if ($this->validateJSON($request)) {
            $this->request = json_decode($request, true);
        } else {
            throw new ApiException(200, "malformed_request", "JSON request could not be decoded, make sure syntax is correct.");
        }


        if (!array_key_exists("type", $this->request)) {
            throw new ApiException(200, "invalid_type", "Type is not specified.");
        }

        if (!array_key_exists("operation", $this->request)) {
            throw new ApiException(200, "invalid_operation", "Operation is not specified.");
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
            case "tournament":
                $this->handleTournament();
		break;
            case "league":
                $this->handleLeague();
                break;
            case "season":
                $this->handleSeason();
                break;
            case "stats":
                $this->handleStats();
            case "eventSites":
                $this->handleEventSites();
                break;
	    case "match":
		$this->handleMatch();
		break;
            default:
                throw new ApiException(200, "invalid_type", "The specified type is not valid.");
                break;
        }

        // Response will be sent after whichever query has executed successfully
        $this->sendResponse();
    }

    private function handlePlayer() {
        $this->authorizeRequest();
        $requiredField = ["data"];
        $this->validateRequiredFields($this->request, $requiredField);

        if ($this->request["operation"] == "set") {
            $this->setPlayers($this->request["data"]);
        } else if ($this->request["operation"] == "get") {
            $this->response = $this->database->getPlayers($this->request);
        } else if ($this->request["operation"] == "add") {
            $this->addPlayers($this->request["data"]);
        } else if ($this->request["operation"] == "delete") {
            $this->deletePlayers($this->request["data"]);
        } else {
            throw new ApiException(200, "invalid_operation", "Invalid operation, only set, get and add is allowed.");
        }
    }

    private function handleStats() {
        $this->authorizeRequest();
        $requiredField = ["data"];
        $this->validateRequiredFields($this->request, $requiredField);

        if ($this->request["operation"] == "set") {
            $this->database->setPlayerStats($this->request["data"]);
        }
    }

    private function handleUser() {
        $this->validateDataField();

        if ($this->request["operation"] == "add") {
            $this->addUser($this->request["data"]);
        } else if ($this->request["operation"] == "set") {
            $this->authorizeRequest();
            $this->setUser($this->request);
        } else if ($this->request["operation"] == "login") {
            $this->loginUser($this->request["data"]);
        } else if ($this->request["operation"] == "delete") {
            $this->deleteUser($this->request["data"]);
        }
    }

    private function handleTeam() {
        $this->authorizeRequest();
        switch ($this->request["operation"]) {
                // case "add": $this->addTeam($this->request["data"]); break;
            case "add": $this->addTeam($this->request["data"]); break;
            case "get": $this->getTeam($this->request["data"]); break;
            case "getAll": $this->response = $this->database->getTeams(); break;
            case "delete": $this->deleteTeam($this->request["data"]); break;
        }
    }

    private function handleSeason() {
        $this->authorizeRequest();
        switch($this->request["operation"]) {
            case "get": $this->getSeason($this->request["data"]); break;
        }
    }

    private function handleEventSites() {
        $this->authorizeRequest();
        switch($this->request["operation"]) {
            case "getAll": $this->response = $this->database->getAllEventSites($this->request["data"]); break;
            case "set": $this->setEventSites($this->request["data"]); break;
        }
    }

    private function handleTournament() {
        if ($this->request["operation"] == "add") {
            $this->addTournament($this->request["data"]);
        } else if ($this->request["operation"] == "get") {
            $this->getTournament($this->request["data"]);
        } else if ($this->request["operation"] == "getMatches") {
            $this->getMatches($this->request["data"]);
        } else {
            throw new ApiException(400, "invalid_operation", "Invalid operation, only set, get and add is allowed.");
        }
    }

    private function handleLeague()
    {
        $this->authorizeRequest();
        switch($this->request["operation"])
        {
            case "get": $this->getLeague($this->request["data"]); break;
        }
    }

    private function handleMatch() {
	if ($this->request["operation"] == "addPlayer") {
	    $this->addPlayerToMatch($this->request["data"]);
	} else if ($this->request["operation"] == "add") {
	    $this->addMatch($this->request["data"]);
	}
    }

    // ======================================================================================
    // OPERATION FUNCTIONS
    // ======================================================================================

    // ==================PLAYERS==================
    function addPlayers($data) {
        $requiredPersonInfo = ["firstName", "lastName", "gender", "DOB", "personKey", "birthAddr"];
        $optionalPersonInfo = ["image"];
        $requiredAddressInfo = ["streetNo", "street", "city", "postalCode", "country", "countryCode"];

        foreach ($data as $object) {
            $this->validateRequiredFields($object, $requiredPersonInfo);
            $this->validateOptionalFields($object, $optionalPersonInfo);
            $this->validateRequiredFields($object["birthAddr"], $requiredAddressInfo);
        }

        $this->database->addPlayers($data);
    }

    function setPlayers($data) {
        $requiredPersonInfo = ["playerID", "firstName", "lastName", "DOB"];
        $optionalPersonInfo = ["image"];

        foreach ($data as $object) {
            $this->validateRequiredFields($object, $requiredPersonInfo);
            $this->validateOptionalFields($object, $optionalPersonInfo);
        }

        $this->database->setPlayers($data);
    }

    function deletePlayers($data) {
        $requiredPersonInfo = ["playerID"];

        foreach ($data as $object) {
            $this->validateRequiredFields($object, $requiredPersonInfo);
        }

        $this->database->deletePlayer($data);
    }


    // ===================USERS===================
    function addUser($data) {
        $requiredUserInfo = ["username", "email", "password"];

        foreach ($data as $user) {
            $this->validateRequiredFields($user, $requiredUserInfo);

            if (count($data) == 1) {
                if (!$this->validateEmail($user["email"])) {
                    throw new ApiException(200, "invalid_email", "Provided email is invalid.");
                }

                if (!$this->validatePassword($user["password"])) {
                    throw new ApiException(200, "invalid_password", "Provided password is invalid.");
                }
            }
        }

        $this->response = $this->database->addUser($this->request["data"]);
    }

    function loginUser($data) {
        $requiredUserInfo = ["email", "password"];
        $this->validateRequiredFields($data[0], $requiredUserInfo);
        $this->response = $this->database->loginUser($data[0]);
    }

    function setUser($data) {
        $user = $data["data"][0];
        $optionalUserInfo = ["username", "email", "password"];
        $this->validateOptionalFields($user, $optionalUserInfo);

        if ($user["username"] == NULL && $user["password"] == NULL && $user["email"] == NULL) {
            throw new ApiException(200, "malformed_request", "New username, email, and password is missing.");
        }

        if ($user["email"] != NULL) {
            if (!$this->validateEmail($user["email"])) {
                throw new ApiException(200, "invalid_email", "Provided email is invalid.");
            }
        }

        if ($user["password"] != NULL) {
            if (!$this->validatePassword($user["password"])) {
                throw new ApiException(200, "invalid_password", "Provided password is invalid.");
            }
        }

        $this->response = $this->database->setUser($user, $data["apiKey"]);
    }

    function deleteUser($data) {
        $requiredUserInfo = ["apiKey"];
        $this->validateRequiredFields($data[0], $requiredUserInfo);
        $this->response = $this->database->deleteUser($data[0]);
    }

    function validateEmail($email) {
        $regex = '/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/';
        return (preg_match($regex, $email) == false) ? false : true;
    }

    function validatePassword($password) {
        $regex = "/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$/";
        return (preg_match($regex, $password) == false) ? false : true;
    }

    // ===================TEAMS===================
    function addTeam($data) {
        $requiredTeamInfo = ["teamName"];
        $optionalTeamInfo = ["homeSite"];
        $requiredHomeSiteInfo = ["streetNo", "street", "city", "postalCode", "country", "countryCode"];
        foreach ($data as $team) {
            $this->validateRequiredFields($team, $requiredTeamInfo);
            $this->validateOptionalFields($team, $optionalTeamInfo);
            if ($team["homeSite"] != null) {
                //If homeSite is specified, we must have all subfields
                $this->validateRequiredFields($team["homeSite"], $requiredHomeSiteInfo);
            }
        }

        $this->response = $this->database->addTeams($this->request["data"]);
    }

    function getTeam($data) {
        $requiredTeamInfo = ["teamID"];
        foreach ($data as $team) {
            $this->validateRequiredFields($team, $requiredTeamInfo);
        }

        $this->response = $this->database->getTeamData($this->request["data"]);
    }

    function deleteTeam($data)
    {
        $requiredTeamInfo = ["teamID"];
        foreach($data as $team)
        {
            $this->validateRequiredFields($team, $requiredTeamInfo);
        }
        $this->response = $this->database->deleteTeam($this->request["data"]);
    }

    // =====================Tournaments=====================
    private function addTournament($data) {
        // normal validation of the required data
        $requiredUserInfo = ["tournamentName", "lineups"];
        $this->validateRequiredFields($data[0], $requiredUserInfo);

        // checking that the data has what it needs
        if (sizeof($data[0]["lineups"]) != 8) {
            throw new ApiException(400, "invalid_parameters", "A invalid amout of lineups was specified. (" .
                sizeof($data["lineups"]) . "was specified, should be 8");
        }
        // validating the lineups parameters
        $count = 0;
        foreach ($data[0]["lineups"] as $lineup) {
            if (!(array_key_exists("teamA", $lineup))) {
                throw new ApiException(400, "invalid_parameters", "teamA was not specified for the " .
                    $count . "th lineup.");
            }
            if (!(array_key_exists("teamB", $lineup))) {
                throw new ApiException(400, "invalid_parameters", "teamB was not specified for the " .
                    $count . "th lineup.");
            }
            $count++;
        }
        // TODO
        // validating the rounds
	$d=strtotime("+3 Months");
	$start =  date("Y-m-d", $d);
	$d=strtotime("+6 Months");
	$end =  date("Y-m-d", $d);
	$this->database->addTournament($data[0]["seasonID"],
	    $start, $end, $data[0]["lineups"], $data[0]["tournamentName"]);
	$this->response = ["good run" => "good run"];
    }

    private function getTournament($data) {
        $this->validateRequiredFields($data[0], ["tournamentID"]);
        $this->response = $this->database->getTournament($data[0]["tournamentID"]);
    }

    private function getMatches($data) {
    }

    // ===================LEAGUES===================

    function getLeague($data)
    {
        $requiredLeagueInfo = ["leagueID"];
        foreach($data as $league)
        {
            $this->validateRequiredFields($league, $requiredLeagueInfo);
        }

        $this->response = $this->database->getLeagueData($this->request["data"]);
    }

    // ===================SEASONS===================

    function getSeason($data)
    {
        $requiredSeasonInfo = ["seasonID"];
        foreach($data as $season)
        {
            $this->validateRequiredFields($season, $requiredSeasonInfo);
        }

        $this->response = $this->database->getSeasonData($this->request["data"]);
    }

    // ===================EVENT SITES===================

    function setEventSites($data)
    {
        $requiredEventSiteInfo = ["siteID", "address"];
        $optionalEventSiteInfo = ["streetNo", "street", "postalCode", "city", "country", "countryCode"];
        foreach($data as $eventSite)
        {
            $this->validateRequiredFields($eventSite, $requiredEventSiteInfo);
            $this->validateRequiredFields($eventSite["address"], $optionalEventSiteInfo);
        }

        $this->response = $this->database->setEventSites($this->request["data"]);
    }
    // ===================Matches=======================
    private function addPlayerToMatch($data) {
	foreach ($data as $player) {
	    $this->database->addPlayerToMatch($player["playerID"], $player["teamID"], $player["matchID"]);
	}
	$this->response = ["data" => "done"];
    }

    private function addMatch($data) {
	foreach ($data as $newMatch) {
	    $this->database->addMatch($newMatch["matchID"], $newMatch["teams"]);
	}
    }

}


// ======================================================================================
// API INSTANCE TO HANDLE INCOMING REQUESTS
// ======================================================================================


// $ownOrigin = $_SERVER['HTTP_OUR_OWN_ORIGIN'];
// header("Access-Control-Allow-Origin: $ownOrigin");
header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
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

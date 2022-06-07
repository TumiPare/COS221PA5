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

            $locAddrIDs = $this->addAddress($birthAddr);

            $query = "INSERT INTO persons (person_key, publisher_id, gender, birth_date, birth_location_id) VALUES (?, ?, ?, ?, ?)";
            $personStmt = $this->executeQuery($query, [$object["personKey"], $this->publisher, $object["gender"], $object["DOB"], $locAddrIDs["locationID"]]);
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

    function getPlayers($data) {
        $data["scope"] = "lifetime";
        $response = [];

        if ($data["scope"] == "lifetime") {
            
            $query = "SELECT * FROM player_data WHERE playerID IN (<?>)";
            $result = $this->multiSelect($query, $data["data"]);
            $playerIds = [];

            foreach ($result as $player) {
                $playerStats = [];

                foreach($player as $key => $value) {
                    $playerStats[$key] = $value;
                }

                $playerStats["stats"] = [];
                array_push($playerIds, $playerStats["playerID"]);
                array_push($response, $playerStats);
            }

            $query = "SELECT * FROM player_offensive_stats WHERE playerID IN (<?>)";
            $result = $this->multiSelectValues($query, $playerIds);

            for ($i = 0; $i < count($response); $i++) {
                $playerStats = array_slice($result[$i], 1, count($result[$i]) - 1);
                $response[$i]["stats"]["offensive"] = $playerStats;
            }

            $query = "SELECT * FROM player_defensive_stats WHERE playerID IN (<?>)";
            $result = $this->multiSelectValues($query, $playerIds);

            for ($i = 0; $i < count($response); $i++) {
                $playerStats = array_slice($result[$i], 1, count($result[$i]) - 1);
                $response[$i]["stats"]["defensive"] = $playerStats;
            }

            $query = "SELECT * FROM player_foul_stats WHERE playerID IN (<?>)";
            $result = $this->multiSelectValues($query, $playerIds);

            for ($i = 0; $i < count($response); $i++) {
                $playerStats = array_slice($result[$i], 1, count($result[$i]) - 1);
                $response[$i]["stats"]["fouls"] = $playerStats;
            }

            return $response;
        } else {
            throw new ApiException(200, "invalid_scope", "Invalid player statistics scope.");
        }

        return $response;
    }

    // ======================================================================================
    // TEAM FUNCTIONS
    // ======================================================================================

    function generateTeamKey($teamName) {
        return strToLower(implode(".", preg_split('/\s+/', $teamName)));
    }

    function generateSiteKey($street, $city, $addrID)
    {
        return strToLower(preg_split('/\s+/', $street)[0] . ", $city ($addrID)");
    }

    function addTeams($data) {
        $response = [];

        foreach ($data as $team) {
            $teamName = $team["teamName"];
            $teamKey = $this->generateTeamKey($teamName);

            $siteID = null;
            if($team["homeSite"] != null)
            {
                //Add location and address
                $locAddrIDs = $this->addAddress($team["homeSite"]);

                //Add site
                $query = "INSERT INTO sites (site_key, publisher_id, location_id) VALUES (?, ?, ?)";
                $siteKey = $this->generateSiteKey($team["homeSite"]["street"], $team["homeSite"]["city"], $locAddrIDs["locationID"]);
                $siteStmt = $this->executeQuery($query, [$siteKey, $this->publisher, $locAddrIDs["locationID"]]);
                $siteID = $this->getLastGeneratedID();
            }

            $query = "INSERT INTO teams (team_key, publisher_id, home_site_id) VALUES (?, ?, ?)";
            $teamStmt = $this->executeQuery($query, [$teamKey, $this->publisher, $siteID]);
            $teamId = $this->getLastGeneratedID();

            $query = "INSERT INTO display_names (language, entity_type, entity_id, full_name) VALUES (?, ?, ?, ?)";
            $displayNameStmt = $this->executeQuery($query, ["en-US", "teams", $teamId, $teamName]);

            //Add team logo
            $query = "INSERT INTO media (b64_image, publisher_id) VALUES (?, ?)";
            $mediaStmt = $this->executeQuery($query, [$team["teamLogo"], $this->publisher]);
            $mediaId = $this->getLastGeneratedID();

            $query = "INSERT INTO teams_media (team_id, media_id) VALUES (?, ?)";
            $mediaPersonStmt = $this->executeQuery($query, [$teamId, $mediaId]);

            array_push($response, ["teamID" => $teamId, "teamKey" => $teamKey]);
        }

        return $response;
    }

    function deleteTeam($data) {
        $queries = [
            "DELETE FROM display_names WHERE entity_id IN (<?>) AND entity_type='teams'",
            "DELETE FROM teams_media WHERE team_id IN (<?>)",
            "DELETE FROM teams WHERE `id` IN (<?>)"
        ];
        foreach($queries as $query) { $this->multiExecuteQuery($query, $data); }

        return ["Teams deleted"];
    }

    //Returns the id, team_key, and display_names(full_name) of ALL teams in the DB
    function getTeams() {
        // $query = "SELECT t.id, t.team_key, d.full_name FROM teams t, display_names d WHERE d.entity_type = 'teams' AND d.entity_id = t.id";
        $query = "SELECT t.id, t.team_key, d.full_name FROM display_names d RIGHT JOIN teams t ON t.id = d.entity_id AND d.entity_type = 'teams'";
        $response = $this->select($query);
        return $response;
    }

    //Returns all important data on SPECIFIC teams
    function getTeamData($data) {
        $query = "SELECT * FROM team_data WHERE team_id IN (<?>)";
        $response = $this->multiSelect($query, $data);

        return $response;
    }


    // ======================================================================================
    // Tournament FUNCTIONS
    // ======================================================================================
    // TODO
    public function CreateTourament($affiliation_key=null, $season_key,) {
	// check for a affiliation
	$query = "SELECT id FROM affiliations WHERE affiliation_key = ?;";
	$affiliation_id = $this->select($query, [$affiliation_key]);

        if ($affiliation_id == []) {
            throw new ApiException(401, "invalid_affiliation", "The affiliation that you have specified does not exist.");
        }
	// check for a season add if not
	$query = "SELECT id FROM seasons WHERE league_id = ?;";
	$season_id = $this->select($query, [$affiliation_key]);

        if ($affiliation_id == []) {
            throw new ApiException(401, "invalid_affiliation", "The affiliation that you have specified does not exist.");
        }
	// make tournament
	$query = "INSERT INTO sub_seasons (sub_season_key,season_id,sub_season_type,start_date_time,end_date_time)" .
	    "(?,?,?,?,?)";
	// make events
	// 		if no site make one
	// link teams to events
	// link players to events
    }


    public function getTournament($tournamentID) {
	#TODO Change teams to team
	$query = "SELECT s.event_id, sub_season_id, event_number as match_number, round_number, participant_id as team_id, score FROM
(SELECT * FROM events_sub_seasons) s,
(SELECT events.id, events.event_number, events.round_number FROM events)e,
(SELECT participants_events.event_id, participants_events.participant_id, participants_events.score FROM participants_events
WHERE participants_events.participant_type = 'team')pe
WHERE pe.event_id = e.id AND s.event_id = e.id AND s.sub_season_id = ?;";
	$result = $this->select($query, [$tournamentID]);
	if ($result == []) {
	    throw new ApiException(401, "invalid_tournamentid", "The specified tournament does not have any data accociated wiht it.");
	}
	// the counters for the seperate rounds
	$counters = array(0,0,0,0);
	$matchpaircounter = 0;
	$counters[0]++;
	$team = "teamB";
	$return["tournament"]["tournamentID"] = $tournamentID;
	// adding all the data from the query
	foreach ($result as $value) {
	    if ($team == "teamB") {
		$team = "teamA";
	    } else {
		$team == "teamB";
	    }

	    $roundNo = $value["round_number"]-1;
	    $return["tournament"]["rounds"][$roundNo]["matches"][$counters[$roundNo]]["matchID"] = $value["event_id"];
	    $return["tournament"]["rounds"][$roundNo]["roundNo"] = $value["round_number"];
	    if ($matchpaircounter === 0) {
		$return["tournament"]["rounds"][$roundNo]["matches"][$counters[$roundNo]]["teamA"]["teamID"] = $value["team_id"];
		$return["tournament"]["rounds"][$roundNo]["matches"][$counters[$roundNo]]["teamA"]["points"] = $value["score"];
		$matchpaircounter++;
	    } else {
		$return["tournament"]["rounds"][$roundNo]["matches"][$counters[$roundNo]]["teamB"]["teamID"] = $value["team_id"];
		$return["tournament"]["rounds"][$value["round_number"]-1]["matches"][$counters[$value["round_number"]-1]]["teamB"]["points"] = $value["score"];
		$matchpaircounter = 0;
	    }
	}

	$query = "SELECT full_name FROM display_names WHERE entity_type = 'tournament' AND entity_id = ?;";
	$result = $this->select($query, [$tournamentID]);
	if ($result == []) {
	    $return["tournament"]["tournamentName"] = "No Name";
	} else {
	    $return["tournament"]["tournamentName"] = $result["full_name"];
	}
	return $return;
    }

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

    /**
     * Converts an array with objects to an array of values
     *
     * @param $query e.g. SELECT * FROM table WHERE column IN (<?>)
     * @param $data array of JSON objects
     * @return array
     */
    private function multiSelect($query, $data) {
        $data = $this->convertArrayOfObjects($data);
        $commas = $this->createCommaString(count($data));
        $query = str_replace("<?>", $commas, $query);

        return $this->select($query, $data);
    }

    private function multiExecuteQuery($query, $data) {
        $data = $this->convertArrayOfObjects($data);
        $commas = $this->createCommaString(count($data));
        $query = str_replace("<?>", $commas, $query);

        return $this->executeQuery($query, $data);
    }

    /**
     * Takes an array of values
     * 
     * @param $query e.g. SELECT * FROM table WHERE column IN (<?>)
     * @param $data array of values
     * @return array
     */
    private function multiSelectValues($query, $data) {
        $commas = $this->createCommaString(count($data));
        $query = str_replace("<?>", $commas, $query);

        return $this->select($query, $data);
    }

    /**
     * Converts an array with objects to an array of values
     *
     * @param $data associative array of key values
     * @return array
     */
    private function convertArrayOfObjects($data) {
        $array = [];
        foreach ($data as $object) {
            foreach ($object as $key => $value) {
                array_push($array, $value);
                break;
            }
        }

        return $array;
    }

    private function createCommaString($count) {
        $string = str_repeat("?,", $count);

        return substr($string, 0, strlen($string) - 1);
    }

    //$addr should contain {"streetNo", "street", "city", "postalCode", "country", "countryCode"}
    //Generates the address and corresponding location
    //Returns ("locationID", "addressID") object
    function addAddress($addr) {
        $query = "INSERT INTO locations (city, country, country_code) VALUES (?, ?, ?)";
        $locationStmt = $this->executeQuery($query, [$addr["city"], $addr["country"], $addr["countryCode"]]);
        $locationId = $this->getLastGeneratedID();

        $query = "INSERT INTO addresses (location_id, street_number, street, postal_code, country) VALUES (?, ?, ?, ?, ?)";
        $addressStmt = $this->executeQuery($query, [$locationId, $addr["streetNo"], $addr["street"], $addr["postalCode"], $addr["country"]]);
        $addressId = $this->getLastGeneratedID();

        return ["locationID"=>$locationId, "addressID"=>$addressId];
    }
}

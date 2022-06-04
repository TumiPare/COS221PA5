<?php
class ApiException extends Exception {
	private $status;
	private $error;
	private $id;

	public function __construct($status, $code = "", $message = "", $id = "") {
		$this->status = $status;
		$this->message = $message;
		$this->code = $code;
		$this->id = $id;

		switch ($status) {
			case 200:
				$this->error = "Success";
				break;
			case 400:
				$this->error = "Bad Request";
				break;
			case 401:
				$this->error = "Unauthorized";
				break;
			case 403:
				$this->error = "Forbidden";
				break;
			case 404:
				$this->error = "Not Found";
				break;
			case 454:
				$this->error = "User Already Exists";
				break;
			case 500:
				$this->error = "Internal Server Error";
				break;
		}
	}

	public function sendJsonResponse() {
		header("HTTP/1.1 " . $this->status . " " . $this->error);

		if ($this->message !== "") {
			header("Content-Type: application/json");

			$response = [
				"status" => "failed",
				"timestamp" => time(),
				"error" => [
					"code" => $this->code,
					"message" => $this->message,
				]
			];

			if ($this->id !== "") {
				$response["error"]["id"] = $this->id;
			}
			echo (json_encode($response));
		}
	}
}

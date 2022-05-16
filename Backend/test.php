<?php
require_once './config.php';
$_GET = json_decode(file_get_contents('php://input'), true);

// header('Content-Type:application/json');

echo json_encode(["message" => "API works"]);

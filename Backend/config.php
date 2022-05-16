<?php
$servername = "178.128.33.26";
$username = "blue_church_member";
$password = "blue_church";
$database = "waitless"; // TODO change to the name of our database

// Create connection
$conn = mysqli_connect($servername, $username, $password, $database);

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}

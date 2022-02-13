<?php
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "mypastrydb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn -> connect_error) {
    die("Error connecting to ". $conn->connect_error);
}
?>
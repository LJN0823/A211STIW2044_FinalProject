<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000, 99999);
$na = "na";

$sqlinsert = "INSERT INTO tbl_user (user_phone,user_name,user_password,user_email,user_address,user_loc,otp) VALUES('$phone','$name','$password','$na','$na','$na',$otp)";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
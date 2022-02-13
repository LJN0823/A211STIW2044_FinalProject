<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['image'])) {
    $encoded_string = $_POST['image'];
    $userid = $_POST['userid'];
    $decoded_string = base64_decode($encoded_string);
    $path = '../images/profile/' . $userid . '.png';
    $is_written = file_put_contents($path, $decoded_string);
    if ($is_written){
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else if (isset($_POST['password'])) {
    $password = sha1($_POST['password']);
    $userid = $_POST['userid'];

    $sqlupdate = "UPDATE tbl_user SET user_password ='$password' WHERE user_id = '$userid'";
    if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else {
    $userid = $_POST['userid'];
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];
    $address = $_POST['address'];
    $loc = $_POST['loc'];

    $sqlupdate = "UPDATE tbl_user SET user_phone ='$phone', user_name='$name', user_email='$email', user_loc='$loc', user_address='$address' WHERE  user_id = '$userid'";
    if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
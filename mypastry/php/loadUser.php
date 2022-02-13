<?php
include_once("dbconnect.php");

$phone = $_POST['phone'];
$sqluser = "SELECT * FROM tbl_user WHERE user_phone = '$phone'";

$result = $conn->query($sqluser);
if ($result->num_rows > 0) {
while ($row = $result->fetch_assoc()) {
        $userlist = array();
        $userlist['id'] = $row['user_id'];
        $userlist['phone'] = $row['user_phone'];
        $userlist['name'] = $row['user_name'];
        $userlist['email'] = $row['user_email'];
        $userlist['address'] = $row['user_address'];
        $userlist['regdate'] = $row['user_datereg'];
        $userlist['loc'] = $row['user_loc'];
        $userlist['otp'] = $row['otp'];
        echo json_encode($userlist);
        $conn->close();
        return;
    }
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
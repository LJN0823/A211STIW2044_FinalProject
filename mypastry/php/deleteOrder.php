<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

$prid = $_POST['prid'];
$oiquantity = $_POST['oiquantity'];

$sqldelete = "DELETE FROM `tbl_orderitem` WHERE pr_id = '$prid' AND oi_quantity = '$oiquantity'";
if ($conn->query($sqldelete) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $sqlupdqty = "UPDATE tbl_product SET pr_quantity = pr_quantity + CAST($oiquantity AS INT) WHERE pr_id = '$prid'"; //CAST($oiquantity AS INT)
    $conn->query($sqlupdqty);
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
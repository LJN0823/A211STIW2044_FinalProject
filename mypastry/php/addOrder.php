<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

$prprice = $_POST['prprice'];
$prid = $_POST['prid'];
$quantity = $_POST['quantity'];
$id = $_POST['id'];
$na = '0';

$sqlinsert = "INSERT INTO tbl_orderitem(order_id, pr_id, oi_quantity, pr_price, oi_cusid) VALUES('$na', '$prid', '$quantity', '$prprice', '$id')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $sqlupdqty = "UPDATE tbl_product SET pr_quantity = pr_quantity - $quantity WHERE pr_id = '$prid'";
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
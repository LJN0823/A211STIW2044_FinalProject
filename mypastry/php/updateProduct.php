<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$prid = $_POST['prid'];
$prname = $_POST['prname'];
$prdesc = $_POST['prdesc'];
$prprice = $_POST['prprice'];
$prquantity = $_POST['prquantity'];
$prdelfee = $_POST['prdelfee'];
if (isset($_POST['image'])) {
    $encoded_string = $_POST['image'];
}

$sqlupdate = "UPDATE tbl_product SET pr_name = '$prname', pr_price = '$prprice', pr_quantity = '$prquantity', pr_desc = '$prdesc',pr_delfee = '$prdelfee' WHERE  pr_id = '$prid'";
if ($conn->query($sqlupdate) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    if (!empty($encoded_string)) {
        $decoded_string = base64_decode($encoded_string);
        $path = '../mypastry/images/products/' . $prid . '.png';
        $is_written = file_put_contents($path, $decoded_string);
    }
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
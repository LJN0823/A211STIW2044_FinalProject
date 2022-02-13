<?php
include_once("dbconnect.php");

if (isset($_POST['prid'])) {
    $prid = $_POST['prid'];
    $sqlloadproduct = "SELECT * FROM tbl_product WHERE pr_id = '$prid'";
    $result = $conn->query($sqlloadproduct);
if ($result->num_rows > 0) {
while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['prid'] = $row['pr_id'];
        $prlist['prname'] = $row['pr_name'];
        $prlist['prdesc'] = $row['pr_desc'];
        $prlist['prprice'] = $row['pr_price'];
        $prlist['prquantity'] = $row['pr_quantity'];
        $prlist['prdelfee'] = $row['pr_delfee'];
        $prlist['prdate'] = $row['pr_date'];
    }
     $response = array('status' => 'success', 'data' => $prlist);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
}
else{
$sqlloadproduct = "SELECT * FROM tbl_product ORDER BY pr_date DESC";
$result = $conn->query($sqlloadproduct);
if ($result->num_rows > 0) {
     $products["products"] = array();
while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['prid'] = $row['pr_id'];
        $prlist['prname'] = $row['pr_name'];
        $prlist['prdesc'] = $row['pr_desc'];
        $prlist['prprice'] = $row['pr_price'];
        $prlist['prquantity'] = $row['pr_quantity'];
        $prlist['prdelfee'] = $row['pr_delfee'];
        $prlist['prdate'] = $row['pr_date'];
        array_push($products["products"],$prlist);
    }
     $response = array('status' => 'success', 'data' => $products);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
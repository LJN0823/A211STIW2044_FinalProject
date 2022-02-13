<?php
include_once("dbconnect.php");

if (isset($_POST['orreceiptID']) && isset($_POST['id']) && isset($_POST['orid'])) { //orreceiptID for load details
    $orreceiptID = $_POST['orreceiptID'];
    $id = $_POST['id'];
    $orderid = $_POST['orid'];
    $sqlloadorder = "SELECT * FROM tbl_order o JOIN tbl_orderitem oi ON o.order_id = oi.order_id JOIN tbl_product pr ON oi.pr_id = pr.pr_id 
    WHERE o.order_receiptID = '$orreceiptID' AND o.order_id = $orderid AND oi_cusid = $id 
    ORDER BY oi.order_id";
    $result = $conn->query($sqlloadorder);
    if ($result->num_rows > 0) {
        $orders["orders"] = array();
        while ($row = $result->fetch_assoc()) {
            $orlist = array();
            $orlist['orderid'] = $row['order_id'];
            $orlist['orpaid'] = $row['order_paid'];
            $orlist['ordate'] = $row['order_date'];
            $orlist['oiquantity'] = $row['oi_quantity'];
            $orlist['prid'] = $row['pr_id'];
            $orlist['prname'] = $row['pr_name'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['prdelfee'] = $row['pr_delfee'];
            array_push($orders["orders"],$orlist);
        }
         $response = array('status' => 'success', 'data' => $orders);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else if (isset($_POST['id']) && isset($_POST['orid'])) { 
    $id = $_POST['id']; //userid and orderid for load all history for owner
    $orderid = $_POST['orid'];
    $sqlloadorder = "SELECT * FROM tbl_orderitem JOIN tbl_product ON tbl_orderitem.pr_id = tbl_product.pr_id WHERE order_id = $orderid AND oi_cusid = $id ORDER BY tbl_orderitem.pr_id DESC";
    $result = $conn->query($sqlloadorder);
    if ($result->num_rows > 0) {
        $orders["orders"] = array();
    while ($row = $result->fetch_assoc()) {
            $orlist = array();
            $orlist['prid'] = $row['pr_id'];
            $orlist['orderid'] = $row['order_id'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['oiquantity'] = $row['oi_quantity'];
            $orlist['oicusid'] = $row['oi_cusid'];
            $orlist['prname'] = $row['pr_name'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['prdelfee'] = $row['pr_delfee'];
            array_push($orders["orders"],$orlist);
        }
        $response = array('status' => 'success', 'data' => $orders);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else if (isset($_POST['id'])) {
    $id = $_POST['id']; //userid for load all from user
    $sqlloadorder = "SELECT * FROM tbl_order WHERE order_cusID = $id ORDER BY order_id DESC";
    $result = $conn->query($sqlloadorder);
    if ($result->num_rows > 0) {
        $orders["orders"] = array();
    while ($row = $result->fetch_assoc()) {
            $orlist = array();
            $orlist['orreceiptID'] = $row['order_receiptID'];
            $orlist['orid'] = $row['order_id'];
            $orlist['orcusID'] = $row['order_cusID'];
            $orlist['orpaid'] = $row['order_paid'];
            $orlist['orstatus'] = $row['order_status'];
            $orlist['ordate'] = $row['order_date'];
            array_push($orders["orders"],$orlist);
        }
        $response = array('status' => 'success', 'data' => $orders);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else { //load all history order
    $sqlloadorder = "SELECT * FROM tbl_order ORDER BY order_id DESC";
    $result = $conn->query($sqlloadorder);
    if ($result->num_rows > 0) {
        $orders["orders"] = array();
    while ($row = $result->fetch_assoc()) {
            $orlist = array();
            $orlist['orreceiptID'] = $row['order_receiptID'];
            $orlist['orid'] = $row['order_id'];
            $orlist['orcusID'] = $row['order_cusID'];
            $orlist['orpaid'] = $row['order_paid'];
            $orlist['orstatus'] = $row['order_status'];
            $orlist['ordate'] = $row['order_date'];
            array_push($orders["orders"],$orlist);
        }
        $response = array('status' => 'success', 'data' => $orders);
        sendJsonResponse($response);
    }else{
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
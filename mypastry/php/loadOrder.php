<?php
include_once("dbconnect.php");

if (isset($_POST['prid'])) { //prid for load details
     $prid = $_POST['prid'];
      $sqlloadorder = "SELECT * FROM tbl_orderitem JOIN tbl_product ON tbl_orderitem.pr_id = tbl_product.pr_id WHERE order_id = 0 AND tbl_product.pr_id = $prid";
      $result = $conn->query($sqlloadorder);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $orlist = array();
            $orlist['orderid'] = $row['order_id'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['oiquantity'] = $row['oi_quantity'];
            $orlist['oicusid'] = $row['oi_cusid'];
            $orlist['prid'] = $row['pr_id'];
            $orlist['prname'] = $row['pr_name'];
            $orlist['prdesc'] = $row['pr_desc'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['prquantity'] = $row['pr_quantity'];
            $orlist['prdelfee'] = $row['pr_delfee'];
            $orlist['prdate'] = $row['pr_date'];
        }
        $response = array('status' => 'success', 'data' => $orlist);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} else {
    $id = $_POST['id']; //userid for load all
    $sqlloadorder = "SELECT * FROM tbl_orderitem JOIN tbl_product ON tbl_orderitem.pr_id = tbl_product.pr_id WHERE order_id = 0 AND oi_cusid = $id ORDER BY tbl_orderitem.pr_id DESC";
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
            $orlist['prdesc'] = $row['pr_desc'];
            $orlist['prprice'] = $row['pr_price'];
            $orlist['prquantity'] = $row['pr_quantity'];
            $orlist['prdelfee'] = $row['pr_delfee'];
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
<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$email = $_GET['email'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed= hash_hmac('sha256', $signing, 'S-R_TQviry3YXDxSXRszLAbw');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success 
        $sqlinsert = "INSERT INTO tbl_order(order_receiptID, order_id, order_cusID, order_paid, order_status) 
        SELECT '$receiptid',COUNT(order_id)+1,$userid,'$amount','Delivering'
        FROM tbl_order
        WHERE order_cusID = $userid";
        $conn->query($sqlinsert);
        $sqlupdoi = "UPDATE `tbl_orderitem` SET `order_id`= (SELECT order_id FROM tbl_order WHERE order_receiptID = '$receiptid') WHERE order_id = 0 AND oi_cusid = $userid";
        $conn->query($sqlupdoi);
        //echo 'Payment Success!';
        echo '<br><br><body><div><h2><br><center><tr>
        <td class="content-block">
            <h2>Thanks for using our app</h2>
        </td></center>
    </tr><br><center>Receipt</center></h1>
    <table border=1 width=80% align=center><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr>
    <tr><td>Mobile to</td><td>'.$phone.'</td></tr><tr><td>Amount </td><td>RM '.$amount. ' </td></tr>
    <td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
    <tr><td>Time </td><td>'.date("h:i a").'</td></tr></table></div></body>';
    }
    else 
    {
        echo 'Payment Failed!';
    }
}
?>
<?php
include_once("dbconnect.php");

$phone = $_POST['phone'];
$otp = $_POST['otp'];

$sqlverify = "SELECT * FROM tbl_user WHERE user_phone = '$phone' AND otp = '$otp'";
$result = $conn->query($sqlverify);

if ($result->num_rows > 0)
{
   $newotp = '1';
   $sqlupdate = "UPDATE tbl_user SET otp = '$newotp' WHERE user_phone = '$phone'";
  if ($conn->query($sqlupdate) === TRUE){
        echo "success";
  }else{
      echo "failed";;
  }
}
?>
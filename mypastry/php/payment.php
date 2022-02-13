<?php
error_reporting(0);

$phone = $_GET['phone'];
$userid = $_GET['userid'];
$email = $_GET['email']; //email
$name = $_GET['name'];
$amount = $_GET['amount'];
$myconf = $_GET['myconf'];

$api_key = 'ac997600-6cba-4e27-bb01-0042fe7b7df4';
$collection_id = 'zxxkt9jw';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'userid' => $userid,
          'phone' => $phone,
          'name' => $name,
          'amount' => $amount * 100,
		  'description' => 'Payment for order by '.$name,
          'callback_url' => "$myconf/mypastry/return_url",
          'redirect_url' => "$myconf/mypastry/php/updatePayment.php?userid=$userid&phone=$phone&amount=$amount&email=$email" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>
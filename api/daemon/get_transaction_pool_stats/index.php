<?php 
//*desc: Gets transaction pool statistics
require_once('../../lib/config.php');

$ch = curl_init();
$url = 'http://'.HOST.':'.DAEMON_PORT.'/get_transaction_pool_stats';

curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$obj=curl_exec($ch);
curl_close($ch);

echo $obj;
?>

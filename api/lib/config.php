<?php 
define('HOST', 'localhost');
define('DAEMON_PORT', 17566);
define('WALLET_PORT', 3001);
define('DEBUG', true);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if (DEBUG)
{
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
}
?>

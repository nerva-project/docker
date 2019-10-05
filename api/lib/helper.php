<?php 
function generate_json_rpc_header($method, $params)
{
    $header = array(
        "jsonrpc" => "2.0",
        "id" => "0",
        "method" => $method
    );

    if ($params != NULL)
        $header["params"] = $params;

    return json_encode($header);
}

function send_json_rpc_request($host, $port, $method, $params)
{
    $s = generate_json_rpc_header($method, $params);

    $ch = curl_init();
    $url = 'http://'.$host.':'.$port.'/json_rpc';

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $s);
    $obj=curl_exec($ch);
    curl_close($ch);

    return $obj;
}

function send_rpc_request($host, $port, $method, $params)
{
    $url = 'http://'.$host.':'.$port.'/'.$method;
    
    $s = null;
    if ($params != null) {
        $s = json_encode($params);
    }

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $s);
    $obj=curl_exec($ch);
    curl_close($ch);

    return $obj;
}

function send_json_rpc_request_preformatted($host, $port, $method, $params)
{
    $ch = curl_init();
    $url = 'http://'.$host.':'.$port.'/json_rpc';

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $params);
    $obj=curl_exec($ch);
    curl_close($ch);

    return $obj;
}
?>
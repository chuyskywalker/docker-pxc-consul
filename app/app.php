<?php

// Reconfigure the lookup system
`echo "nameserver "$(grep consulserver /etc/hosts | awk '{print $1}') > /etc/resolv.conf`;

// need this to work with ctrl-c
declare(ticks=1);
function signalHandler($signo) {
    echo "bye!\n";
    exit;
}
pcntl_signal(SIGINT, 'signalHandler');

// get reactphp
require 'vendor/autoload.php';

// the "router" (lol)
$app = function ($request, $response) {

    echo 'Request for: ' . $request->getPath(), PHP_EOL;

    if ($request->getPath() === '/' || $request->getPath() === '') {
        $response->writeHead(200, array('Content-Type' => 'text/html'));
        $response->end("<p>Welcome You!
<p><a href='/dns'>dns</a></p>
<p><a href='/dnsall'>dnsall</a></p>
<p><a href='/query'>query random server</a></p>
");
    }
    elseif ($request->getPath() === '/query') {
        $sql = "show variables like 'wsrep_node_name';";
        $m = new mysqli('pxc.service.consul', 'monitor', 's3cret');
        if ($m->connect_error) {
            $result = 'Connect Error (' . $m->connect_errno . ') '. $m->connect_error;
        }
        else {
            $result = $m->query($sql)->fetch_assoc();
        }
        $response->writeHead(200, array('Content-Type' => 'text/html'));
        $response->end("<p>query: $sql<br><br>Result: <pre>" . print_r($result,1));
    }
    elseif ($request->getPath() === '/dnsall') {
        $response->writeHead(200, array('Content-Type' => 'text/html'));
        $response->end("<p>ALL DNS:<br><pre>" . print_r(dns_get_record('pxc.service.consul', DNS_ALL),1));
    }
    elseif ($request->getPath() === '/dns') {
        $response->writeHead(200, array('Content-Type' => 'text/html'));
        $response->end("<p>DNS:<br><pre>" . print_r(dns_get_record('pxc.service.consul'),1));
    }
    else {
		$response->writeHead(404, array('Content-Type' => "text/plain" ));
		$response->end("HTTP 404 - File not found");
    }

};

$loop   = React\EventLoop\Factory::create();
$socket = new React\Socket\Server($loop);
$http   = new React\Http\Server($socket, $loop);
$http->on('request', $app);
$socket->listen(80, '0.0.0.0');
echo "Server running at http://127.0.0.1:80\n";

$loop->run();

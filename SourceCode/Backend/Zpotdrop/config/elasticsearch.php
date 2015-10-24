<?php

return array(

    'connectionClass' => '\Elasticsearch\Connections\GuzzleConnection',
    'connectionFactoryClass' => '\Elasticsearch\Connections\ConnectionFactory',
    'connectionPoolClass' => '\Elasticsearch\ConnectionPool\StaticNoPingConnectionPool',
    'selectorClass' => '\Elasticsearch\ConnectionPool\Selectors\RoundRobinSelector',
    'serializerClass' => '\Elasticsearch\Serializers\SmartSerializer',

    'sniffOnStart' => false,
    'connectionParams' => array(),
    'hosts' => array (
        'localhost:9200',                 // IP + Port
        //'192.168.1.2',                      // Just IP
        //'mydomain.server.com:9201',         // Domain + Port
        //'mydomain2.server.com',             // Just Domain
        //'https://localhost',                // SSL to localhost
        //'https://192.168.1.3:9200',         // SSL to IP + Port
        // 'http://user:pass@localhost:9200',  // HTTP Basic Auth
        //'https://user:pass@localhost:9200',  // SSL + HTTP Basic Auth
    ),
    'logging' => false,
    'logObject' => null,
    'logPath' => storage_path().'/logs/elasticsearch.log',
    'logLevel' => Monolog\Logger::WARNING,
    'traceObject' => null,
    'tracePath' => storage_path().'/logs/elasticsearch_trace.log',
    'traceLevel' => Monolog\Logger::WARNING,
    'guzzleOptions' => array(),
    'connectionPoolParams' => array(
        'randomizeHosts' => true
    ),
    'retries' => null

);
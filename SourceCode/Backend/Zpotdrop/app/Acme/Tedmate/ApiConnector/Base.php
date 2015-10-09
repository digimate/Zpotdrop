<?php
namespace Tedmate\ApiConnector;

use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\json_decode;
use Carbon\Carbon;

use Tedmate\ApiConnector\ConnectorInterface;
use Tedmate\ApiConnector\UrlBuilder;
class Base extends Connector implements ConnectorInterface 
{
	protected $header = array();
	protected $body   = array();
	protected $options= array();
	public function __construct( $config = array() ) 
	{
		parent::__construct($config);
	}
	public function example($id)
	{
		// this link could put in config
		$link = '/users/{id}';
		$url = UrlBuilder::buildUrl($link, array('id' => $id ) );
		return $this->get($url, $this->header, $this->body, $this->options);
	}
	
}

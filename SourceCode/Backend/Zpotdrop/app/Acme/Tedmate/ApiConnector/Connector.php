<?php
namespace Tedmate\ApiConnector;

use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\Subscriber\Oauth\Oauth1;
use GuzzleHttp\json_decode;
use Carbon\Carbon;
use \Exception;
class Connector 
{

	/**
	 * URL
	 */
	protected $baseUrl = '';
	/*
	*	Consumer key
	*/
	protected $client_id = '';
	/**
	 *  Consumer secret
	 */
	protected $client_secret = '';

	/**
	 * Guzzle client
	 *
	 * @var \GuzzleHttp\Client
	 */
	protected $client = null;

	
	public function __construct($configs) 
	{
		if(! empty($configs['base_url']) ) {
			$this->baseUrl = $configs['base_url'];
		}
		if(! empty( $configs['client_id']) ) {
			$this->client_id = $configs['client_id'];
		}
		if(! empty($configs['client_secret'])) {
			$this->client_secret = $configs['client_secret'];
		}
		if( empty($this->client_id) || empty($this->client_secret) ){
			throw new Exception("Don\'t provide client_id or client_secret", 1);
		}
		$args = [
					'base_url' => $this->baseUrl, 
					'headers' => ['Content-Type' => 'application/json'],
					'defaults' => ['auth' => 'oauth'] 
				];
		$oauth = new Oauth1([
								'consumer_key'    => $this->client_id,
								'consumer_secret' => $this->client_secret
				]);
		$this->client = new \GuzzleHttp\Client($args);
		$this->client->getEmitter()->attach($oauth);
	}

	public function post($url, $data ) 
	{
		
		$content    = null;
		$statusCode = null;
		$message    = '';
		
		if( !isset($data) )
		{
			$data = array();
		}
		try 
		{
		
			$httpResponse = $this->client->post($url,['body' => $data]);			
	
			$statusCode = $httpResponse->getStatusCode();
			$body = $httpResponse->getBody();
			
			$unreadBytes = $body->getMetadata()['unread_bytes'];			
			
			if($unreadBytes > 0) 
			{
				$content = $body->getContents();
			} 
			else 
			{
				$content = (string)$body;
			}
		} 
		catch(RequestException $re) 
		{
			if($re->hasResponse()) 
			{
				$httpErrorResponse = $re->getResponse();
				$statusCode = $httpErrorResponse->getStatusCode();
				$body = $httpErrorResponse->getBody();
				$unreadBytes = $body->getMetadata()['unread_bytes'];
				if($unreadBytes > 0) 
				{
					$content = $body->getContents();
				} 
				else 
				{
					$content = (string)$body;
				}
				
			}
			if(empty($conntent)) {
				$content = $this->_errorDefault();
			}
		}
		return $content;
	}
	public function get($url, $data = array() ) 
	{
		$content = null;
		$statusCode = null;
		$message = '';
		try 
		{

			$httpResponse = $this->client->get($url, ['body'=>$data] );
			$statusCode = $httpResponse->getStatusCode();
			$body = $httpResponse->getBody();

			$unreadBytes = $body->getMetadata()['unread_bytes'];
			if($unreadBytes > 0) 
			{
				$content = $body->getContents();
			} 
			else 
			{
				$content = (string)$body;
			}
		} 
		catch(RequestException $re) 
		{
		
			if($re->hasResponse()) 
			{
				$httpErrorResponse = $re->getResponse();

				$statusCode = $httpErrorResponse->getStatusCode();
				$body = $httpErrorResponse->getBody();
				$unreadBytes = $body->getMetadata()['unread_bytes'];
				if($unreadBytes > 0) 
				{
					$content = $body->getContents();
				} 
				else 
				{
					$content = (string)$body;
				}
			}
			if(empty($conntent)) {
				$content = $this->_errorDefault();
			}
		}
		return $content;
	}
	public function delete($url, $data = array() ) 
	{
		$content    = null;
		$statusCode = null;
		$message    = '';
		try 
		{

			$httpResponse = $this->client->delete($url ,[ 'body' => $data ] );

			$statusCode = $httpResponse->getStatusCode();
			$body = $httpResponse->getBody();

			$unreadBytes = $body->getMetadata()['unread_bytes'];
			if($unreadBytes > 0) 
			{
				$content = $body->getContents();
			} 
			else 
			{
				$content = (string)$body;
			}
		} 
		catch(RequestException $re) 
		{
			$message = $re->getMessage();

			if($re->hasResponse()) 
			{
				$httpErrorResponse = $re->getResponse();

				$statusCode = $httpErrorResponse->getStatusCode();
				$body = $httpErrorResponse->getBody();
				$unreadBytes = $body->getMetadata()['unread_bytes'];
				if($unreadBytes > 0) 
				{
					$content = $body->getContents();
				} 
				else 
				{
					$content = (string)$body;
				}
			}
			if(empty($conntent)) {
				$content = $this->_errorDefault();
			}
		}
		return $content;
	}
	public function put($url, $data = array() ) 
	{
		$content    = null;
		$statusCode = null;
		$message    = '';
		try 
		{

			$httpResponse = $this->client->put($url ,['body' => $data]);

			$statusCode = $httpResponse->getStatusCode();
			$body = $httpResponse->getBody();

			$unreadBytes = $body->getMetadata()['unread_bytes'];
			if($unreadBytes > 0) 
			{
				$content = $body->getContents();
			} 
			else 
			{
				$content = (string)$body;
			}
		} 
		catch(RequestException $re) 
		{
			$message = $re->getMessage();

			if($re->hasResponse()) 
			{
				$httpErrorResponse = $re->getResponse();

				$statusCode = $httpErrorResponse->getStatusCode();
				$body = $httpErrorResponse->getBody();
				$unreadBytes = $body->getMetadata()['unread_bytes'];
				if($unreadBytes > 0) 
				{
					$content = $body->getContents();
				} 
				else 
				{
					$content = (string)$body;
				}
			}
			if(empty($conntent)) {
				$content = $this->_errorDefault();
			}
		}
		return $content;	
	}
	private function _errorDefault() {
		$response = [
			'result' => [
				'status' => 'error', 'code' => 500, 'message' => 'Internal error',
				'server' => $_SERVER['SERVER_ADDR'], 'time' => time(), 'version' => 1,
				'errors' => []
			]
		];
		return @json_encode($response);
	}
}

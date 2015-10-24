<?php

/*
|--------------------------------------------------------------------------
| LZResponse.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 Zpotdrop.
| @Date       : 7/28/15 - 11:50 PM
*/
namespace App\Acme\Restful;

use App\Acme\Transformers\Transformer;
use League\Fractal;

class LZResponse{
	const HTTP_CONTINUE = 100;
	const HTTP_SWITCHING_PROTOCOLS = 101;
	const HTTP_PROCESSING = 102;            // RFC2518
	const HTTP_OK = 200;
	const HTTP_CREATED = 201;
	const HTTP_ACCEPTED = 202;
	const HTTP_NON_AUTHORITATIVE_INFORMATION = 203;
	const HTTP_NO_CONTENT = 204;
	const HTTP_RESET_CONTENT = 205;
	const HTTP_PARTIAL_CONTENT = 206;
	const HTTP_MULTI_STATUS = 207;          // RFC4918
	const HTTP_ALREADY_REPORTED = 208;      // RFC5842
	const HTTP_IM_USED = 226;               // RFC3229
	const HTTP_MULTIPLE_CHOICES = 300;
	const HTTP_MOVED_PERMANENTLY = 301;
	const HTTP_FOUND = 302;
	const HTTP_SEE_OTHER = 303;
	const HTTP_NOT_MODIFIED = 304;
	const HTTP_USE_PROXY = 305;
	const HTTP_RESERVED = 306;
	const HTTP_TEMPORARY_REDIRECT = 307;
	const HTTP_PERMANENTLY_REDIRECT = 308;  // RFC7238
	const HTTP_BAD_REQUEST = 400;
	const HTTP_UNAUTHORIZED = 401;
	const HTTP_PAYMENT_REQUIRED = 402;
	const HTTP_FORBIDDEN = 403;
	const HTTP_NOT_FOUND = 404;
	const HTTP_METHOD_NOT_ALLOWED = 405;
	const HTTP_NOT_ACCEPTABLE = 406;
	const HTTP_PROXY_AUTHENTICATION_REQUIRED = 407;
	const HTTP_REQUEST_TIMEOUT = 408;
	const HTTP_CONFLICT = 409;
	const HTTP_GONE = 410;
	const HTTP_LENGTH_REQUIRED = 411;
	const HTTP_PRECONDITION_FAILED = 412;
	const HTTP_REQUEST_ENTITY_TOO_LARGE = 413;
	const HTTP_REQUEST_URI_TOO_LONG = 414;
	const HTTP_UNSUPPORTED_MEDIA_TYPE = 415;
	const HTTP_REQUESTED_RANGE_NOT_SATISFIABLE = 416;
	const HTTP_EXPECTATION_FAILED = 417;
	const HTTP_I_AM_A_TEAPOT = 418;                                               // RFC2324
	const HTTP_UNPROCESSABLE_ENTITY = 422;                                        // RFC4918
	const HTTP_LOCKED = 423;                                                      // RFC4918
	const HTTP_FAILED_DEPENDENCY = 424;                                           // RFC4918
	const HTTP_RESERVED_FOR_WEBDAV_ADVANCED_COLLECTIONS_EXPIRED_PROPOSAL = 425;   // RFC2817
	const HTTP_UPGRADE_REQUIRED = 426;                                            // RFC2817
	const HTTP_PRECONDITION_REQUIRED = 428;                                       // RFC6585
	const HTTP_TOO_MANY_REQUESTS = 429;                                           // RFC6585
	const HTTP_REQUEST_HEADER_FIELDS_TOO_LARGE = 431;                             // RFC6585
	const HTTP_INTERNAL_SERVER_ERROR = 500;
	const HTTP_NOT_IMPLEMENTED = 501;
	const HTTP_BAD_GATEWAY = 502;
	const HTTP_SERVICE_UNAVAILABLE = 503;
	const HTTP_GATEWAY_TIMEOUT = 504;
	const HTTP_VERSION_NOT_SUPPORTED = 505;
	const HTTP_VARIANT_ALSO_NEGOTIATES_EXPERIMENTAL = 506;                        // RFC2295
	const HTTP_INSUFFICIENT_STORAGE = 507;                                        // RFC4918
	const HTTP_LOOP_DETECTED = 508;                                               // RFC5842
	const HTTP_NOT_EXTENDED = 510;                                                // RFC2774
	const HTTP_NETWORK_AUTHENTICATION_REQUIRED = 511;                             // RFC6585

	/**
	 * Status codes translation table.
	 *
	 * The list of codes is complete according to the
	 * {@link http://www.iana.org/assignments/http-status-codes/ Hypertext Transfer Protocol (HTTP) Status Code Registry}
	 * (last updated 2012-02-13).
	 *
	 * Unless otherwise noted, the status code is defined in RFC2616.
	 *
	 * @var array
	 */
	public static $statusTexts = array(
		100 => 'Continue',
		101 => 'Switching Protocols',
		102 => 'Processing',            // RFC2518
		200 => 'OK',
		201 => 'Created',
		202 => 'Accepted',
		203 => 'Non-Authoritative Information',
		204 => 'No Content',
		205 => 'Reset Content',
		206 => 'Partial Content',
		207 => 'Multi-Status',          // RFC4918
		208 => 'Already Reported',      // RFC5842
		226 => 'IM Used',               // RFC3229
		300 => 'Multiple Choices',
		301 => 'Moved Permanently',
		302 => 'Found',
		303 => 'See Other',
		304 => 'Not Modified',
		305 => 'Use Proxy',
		306 => 'Reserved',
		307 => 'Temporary Redirect',
		308 => 'Permanent Redirect',    // RFC7238
		400 => 'Bad Request',
		401 => 'Unauthorized',
		402 => 'Payment Required',
		403 => 'Forbidden',
		404 => 'Not Found',
		405 => 'Method Not Allowed',
		406 => 'Not Acceptable',
		407 => 'Proxy Authentication Required',
		408 => 'Request Timeout',
		409 => 'Conflict',
		410 => 'Gone',
		411 => 'Length Required',
		412 => 'Precondition Failed',
		413 => 'Request Entity Too Large',
		414 => 'Request-URI Too Long',
		415 => 'Unsupported Media Type',
		416 => 'Requested Range Not Satisfiable',
		417 => 'Expectation Failed',
		418 => 'I\'m a teapot',                                               // RFC2324
		422 => 'Unprocessable Entity',                                        // RFC4918
		423 => 'Locked',                                                      // RFC4918
		424 => 'Failed Dependency',                                           // RFC4918
		425 => 'Reserved for WebDAV advanced collections expired proposal',   // RFC2817
		426 => 'Upgrade Required',                                            // RFC2817
		428 => 'Precondition Required',                                       // RFC6585
		429 => 'Too Many Requests',                                           // RFC6585
		431 => 'Request Header Fields Too Large',                             // RFC6585
		500 => 'Internal Server Error',
		501 => 'Not Implemented',
		502 => 'Bad Gateway',
		503 => 'Service Unavailable',
		504 => 'Gateway Timeout',
		505 => 'HTTP Version Not Supported',
		506 => 'Variant Also Negotiates (Experimental)',                      // RFC2295
		507 => 'Insufficient Storage',                                        // RFC4918
		508 => 'Loop Detected',                                               // RFC5842
		510 => 'Not Extended',                                                // RFC2774
		511 => 'Network Authentication Required',                             // RFC6585
	);

	protected $errors;
	protected $data;
	protected $message;
	protected $code;
	protected $fractal;

	/**
	 * LZResponse constructor.
	 */
	public function __construct($data = [], $code = 200, $message = 'OK', $error = [])
	{
		$this->setCode($code);
		$this->setMessage($message);
		$this->setErrors($error);
		$this->setData($data);
		$this->fractal = new Fractal\Manager();
		$this->fractal->setSerializer(new Fractal\Serializer\ArraySerializer());
	}

	/**
	 * @param mixed $data
	 */
	public function setData($data)
	{
		$this->data = $data;
	}

	/**
	 * @param mixed $message
	 */
	public function setMessage($message)
	{
		$this->message = $message;
	}

	/**
	 * @param mixed $code
	 */
	public function setCode($code)
	{
		$this->code = $code;
	}

	/**
	 * @param mixed $errors
	 */
	public function setErrors($errors)
	{
		$this->errors = $errors;
	}

	/**
	 * @return mixed
	 */
	public function getErrors()
	{
		return $this->errors;
	}

	/**
	 * @return mixed
	 */
	public function getData()
	{
		return $this->data;
	}

	/**
	 * @return mixed
	 */
	public function getMessage()
	{
		return $this->message;
	}

	/**
	 * @return mixed
	 */
	public function getCode()
	{
		return $this->code;
	}

	/*
	|--------------------------------------------------------------------------
	| Response common
	|--------------------------------------------------------------------------
	|
	| Here is where you can register all of the routes for an application.
	| It's a breeze. Simply tell Laravel the URIs it should respond to
	| and give it the controller to call when that URI is requested.
	|
	*/
	/**
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function json()
	{
		switch($this->getCode()){
			case self::HTTP_OK:{
				return response([
					'code'      => $this->getCode(),
					'message'   => $this->getMessage(),
					'data'      => $this->getData()
				], $this->getCode());
			}
			case self::HTTP_BAD_REQUEST:{
				return response([
					'code'      => $this->getCode(),
					'message'   => $this->getMessage(),
					'errors'    => $this->getErrors()
				], $this->getCode());
			}
			default:{
				return response([
					'code'      => $this->getCode(),
					'message'   => $this->getMessage(),
				], $this->getCode());
			}
		}
	}

	/**
	 * @param $data
	 * @param string $message
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function success($data=[], $message = 'OK')
	{
		$this->setData($data);
		$this->setMessage($message);
		return $this->json();
	}

	public function successTransformModel($model, Transformer $transformer, $message='OK'){
		$resource = new Fractal\Resource\Item($model, $transformer);
		$this->setData($this->fractal->createData($resource)->toArray());
		$this->setMessage($message);
		return $this->json();
	}

	public function successTransformArrayModels($array_model=[], Transformer $transformer, $message='OK'){
		$resource = new Fractal\Resource\Collection($array_model, $transformer);
		$result = $this->fractal->createData($resource)->toArray();
		$this->setData($result['data']);
		$this->setMessage($message);
		return $this->json();
	}

    public function successTransformArrayModelsWithPagination($pagination, Transformer $transformer, $message='OK'){
        $data['paginator'] = [
            'total_count' => $pagination->total(),
            'total_pages' => $pagination->lastPage(),
            'current_page' => $pagination->currentPage()
        ];

        $resource = new Fractal\Resource\Collection($pagination->all(), $transformer);
        $result = $this->fractal->createData($resource)->toArray();
        $data['items'] = $result['data'];
        unset($result);

        $this->setData($data);
        $this->setMessage($message);
        return $this->json();
    }


    public function successTransformArrayModelsWithElasticPagination($pagination, Transformer $transformer, $currentPage, $limit, $message='OK'){
        $data['paginator'] = [
            'total_count' => $pagination->total(),
            'total_pages' => ceil($pagination->total()/$limit),
            'current_page' => $currentPage
        ];

        $resource = new Fractal\Resource\Collection($pagination, $transformer);
        $result = $this->fractal->createData($resource)->toArray();
        $data['items'] = $result['data'];
        unset($result);

        $this->setData($data);
        $this->setMessage($message);
        return $this->json();
    }

	/**
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function notFound()
	{
		$this->setCode(self::HTTP_NOT_FOUND);
		$this->setMessage(self::$statusTexts[self::HTTP_NOT_FOUND]);
		return $this->json();
	}

	/**
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function unauthorized()
	{
		$this->setCode(self::HTTP_UNAUTHORIZED);
		$this->setMessage(self::$statusTexts[self::HTTP_UNAUTHORIZED]);
		return $this->json();

	}

	/**
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function methodNotAllowed()
	{
		$this->setCode(self::HTTP_METHOD_NOT_ALLOWED);
		$this->setMessage(self::$statusTexts[self::HTTP_METHOD_NOT_ALLOWED]);
		return $this->json();
	}

	/**
	 * @param array $parameters
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function missingParameter($parameters = []){
		$this->setCode(self::HTTP_BAD_REQUEST);
		$this->setMessage('Missing required parameters!');
		$this->setErrors($parameters);
		return $this->json();
	}

	/**
	 * @param array $errors
	 * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
	 */
	public function badRequest($errors = [])
	{
		$this->setErrors($errors);
		$this->setCode(self::HTTP_BAD_REQUEST);
		$this->setMessage(self::$statusTexts[self::HTTP_BAD_REQUEST]);
		return self::json();
	}

    /**
     * @param int $code
     * @param string $message
     * @return \Illuminate\Contracts\Routing\ResponseFactory|\Symfony\Component\HttpFoundation\Response
     */
    public function error($code, $message = '')
    {
        $this->setCode($code);
        if (empty($message) && array_key_exists($code, self::$statusTexts)) {
            $this->setMessage(self::$statusTexts[$code]);
        } else {
            $this->setMessage($message);
        }
        return self::json();
    }
}
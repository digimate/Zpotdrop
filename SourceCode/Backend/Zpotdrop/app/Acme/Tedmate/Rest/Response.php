<?php

/**
 * This is a class, that a response format
 * @author     Phung, Truong K <truongkimphung1982@gmail.com>
 * @copyright  Copyright (c) 2015
 */
namespace Tedmate\Rest;
# Symfony core
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
#A simple API extension for DateTime.
use Carbon\Carbon;
class Response {

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

	public static function success($payload = null, $message = null, $statusCode = Response::HTTP_OK, $headers = []) {
		$statusCode = (int)$statusCode;
		if(empty($message)) {
			$message = isset(
				\Symfony\Component\HttpFoundation\Response::$statusTexts[$statusCode]) ? \Symfony\Component\HttpFoundation\Response::$statusTexts[$statusCode] : null;
		}

		$response = [
			'result' => [
				'status' => 'success', 'code' => $statusCode, 'message' => $message,
				'server' => $_SERVER['SERVER_ADDR'], 'time' => time(), 'version' => 1
			]
		];

		if(is_array($payload)) {
			$response = array_merge($response, $payload);
		} else if($payload) {
			$response = array_merge($response, [
				'data' => $payload
			]);
		}

		return new JsonResponse($response);
	}

	public static function fail($message, $payload = [], $statusCode = 500, $reason = null,
		$errorCode = null, $headers = []) {
		$statusCode = (int)$statusCode;
		if(empty($reason)) {
			$reason = isset(
				\Symfony\Component\HttpFoundation\Response::$statusTexts[$statusCode]) ? \Symfony\Component\HttpFoundation\Response::$statusTexts[$statusCode] : $message;
		}

		if(empty($message) && ! empty($reason)) {
			$message = $reason;
		}
		$request = Request::createFromGlobals();

		$error = [
			'message' => $message, 'code' => $errorCode ? $errorCode : $statusCode,
			'method' => $request->getMethod(), 'url' => $request->getBasePath()
		];

		if(is_array($payload)) {
			$error = array_merge($error, $payload);
		} else {
			$error = array_merge($error, [
				'data' => $payload
			]);
		}

		$response = [
			'result' => [
				'status' => 'error', 'code' => $statusCode, 'message' => $reason,
				'server' => $_SERVER['SERVER_ADDR'], 'time' => time(), 'version' => 1,
				'errors' => [
					$error
				]
			]
		];
		$response = new JsonResponse($response);		
		return $response;
	}

	// -------------------------------------------------------------------------
	// Response format based-on field selector
	// -------------------------------------------------------------------------

	// Selector reserved chars
	static $selectorReservedChars = [
		'multiple' => ',', 'nested' => '/', 'begin_sub' => '(', 'end_sub' => ')'
	];

	// Default guarded fields
	static $guarded = [
		'password', 'remember_token', 'confirmation_code', 'access_token',
		'access_token_secret'
	];

	// Is associative array or sequential
	static function isAssociativeArray($arr) {
		return array_keys($arr) !== range(0, count($arr) - 1);
	}

	static function startsWithReserved($str) {
		if(empty($str)) {
			return false;
		}

		$chr = $str{0};
		if($chr === static::$selectorReservedChars['multiple'] ||
			 $chr === static::$selectorReservedChars['nested'] ||
			 $chr === static::$selectorReservedChars['begin_sub'] ||
			 $chr === static::$selectorReservedChars['end_sub']) {
			return true;
		}

		return false;
	}

	public static function format(&$response, $fields, $transform = null, $unguarded = false) {

		// Selector
		$selector = static::selector($fields);
		
		// Format the response
		static::formatElement($response, $selector, 0, $transform, $unguarded);
	}

	public static function guard(&$obj, $unguarded = false) {
		$isAssoc = null;
		if(is_array($obj)) {
			$isAssoc = static::isAssociativeArray($obj);

			// Convert to object (recursive)
			$obj = json_decode(json_encode($obj), false);
		}

		if(is_array($obj) && ! $isAssoc) {
			// Clean each element in the array with the whitelist
			foreach($obj as $ele) {
				static::guard($ele, $unguarded);
			}
		} else if(is_object($obj)) {
			// Get all properties of object
			$props = array_keys(get_object_vars($obj));

			// If property not in white list so delete it
			foreach($props as $prop) {
				if(in_array($prop, self::$guarded)) {
					// Not in unguarded
					if(is_array($unguarded)) {
						if(! in_array($prop, $unguarded)) {
							unset($obj->{$prop});
							continue;
						}
					} else if($unguarded != $prop) {
						unset($obj->{$prop});
						continue;
					}
				}

				if($obj->{$prop} instanceof \DateTime) {
					// Format date
					$obj->{$prop} = $obj->{$prop}->getTimestamp();
					continue;
				} else if($obj->{$prop} instanceof Carbon) {
					$obj->{$prop} = $obj->{$prop}->timestamp;
					continue;
				} else if(is_string($obj->{$prop})) {
					if(preg_match('/^(\d{4})-(\d{2})-(\d{2})$/', $obj->{$prop})) {
						$obj->{$prop} = Carbon::createFromFormat('Y-m-d', $obj->{$prop})->startOfDay()->timestamp;
						continue;
					} else if(preg_match(
						'/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/',
						$obj->{$prop})) {
						$obj->{$prop} = Carbon::createFromFormat('Y-m-d H:i:s',
							$obj->{$prop})->timestamp;
						continue;
					}
				}

				// Not unset, format child object
				if(is_array($obj->{$prop}) || is_object($obj->{$prop})) {
					static::guard($obj->{$prop}, $unguarded);
				}
			}
		}
	}

	static function formatElement(&$obj, $whitelist, $level = 0, $transform = null,
		$unguarded = false) {
		if(! $obj) {
			return;
		}

		if(! is_object($whitelist)) {
			// Have no whitelist
			static::guard($obj, $unguarded);
			return;
		}

		$filterProps = array_keys(get_object_vars($whitelist));

		// White list not is array or have no props
		if(count($filterProps) == 0) {
			static::guard($obj, $unguarded);
			return;
		}

		$isAssoc = null;
		if(is_array($obj)) {
			$isAssoc = static::isAssociativeArray($obj);

			// Convert to object (recursive)
			$obj = json_decode(json_encode($obj), false);
		}

		if(is_array($obj) && ! $isAssoc) {
			// Clean each element in the array with the whitelist
			foreach($obj as $ele) {
				static::formatElement($ele, $whitelist, $level, $transform, $unguarded);
			}
		} else {
			if($transform && $level == 0) {
				$transform($obj);
			}

			// Get all properties of object
			$props = array_keys(get_object_vars($obj));

			// If property not in white list so delete it
			foreach($props as $prop) {
				
				// Not in whitelist and not is ID
				if($prop === '_id') {
					$obj->id = $obj->{$prop};
					unset($obj->{$prop});
				} elseif(! in_array($prop, $filterProps) && $prop !== '_id') {
					unset($obj->{$prop});
				} else if(property_exists($whitelist, $prop) &&
					 $whitelist->{$prop} === false) { // in blacklist
					unset($obj->{$prop});
				} else if($prop === 0) {
					unset($obj->{$prop});
				} else {
					if($obj->{$prop} instanceof \DateTime) {
						// Format date
						$obj->{$prop} = $obj->{$prop}->getTimestamp();
						continue;
					} else if($obj->{$prop} instanceof Carbon) {
						$obj->{$prop} = $obj->{$prop}->timestamp;
						continue;
					} else if(is_string($obj->{$prop})) {
						if(preg_match('/^(\d{4})-(\d{2})-(\d{2})$/', $obj->{$prop})) {
							$obj->{$prop} = Carbon::createFromFormat('Y-m-d',
								$obj->{$prop})->startOfDay()->timestamp;
							continue;
						} else if(preg_match(
							'/^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/',
							$obj->{$prop})) {
							$obj->{$prop} = Carbon::createFromFormat('Y-m-d H:i:s',
								$obj->{$prop})->timestamp;
							continue;
						}
					}
					
					
					

					// Format child object
					if(is_array($obj->{$prop}) || is_object($obj->{$prop})) {
						static::formatElement($obj->{$prop}, $whitelist->{$prop},
							$level + 1, $transform, $unguarded);
					}
				}
			}
		}
	}

	public static function selector($fields) {
		$selector = null;

		// Not is whitelist but is fields selector string
		if(is_string($fields)) {
			$selector = static::stringToSelector($fields);

			// Wrong fields selector string format
			if(! $selector || $selector instanceof \Exception) {
				return null;
			}
		} else if(is_array($fields)) {
			// Force sequential array -> object
			$selector = static::arrayToSelector($fields);
		}

		return $selector;
	}

	public static function arrayToSelector($arr) {
		if(! is_array($arr)) {
			return null;
		}

		// Force sequential array -> object
		$obj = new \stdClass();
		foreach($arr as $key => $val) {
			if(is_numeric($key)) {
				$obj->$val = new \stdClass();
			} else {
				if(is_array($val)) {
					$obj->$key = static::arrayToSelector($val);
				} else {
					$obj->$key = new \stdClass();
				}
			}
		}

		return $obj;
	}

	public static function stringToSelector($fields) {
		// -----------------------------------------------------------------------------
		// Parse field selector string to JSON whitelist
		//
		// Field Selector Reserved Characters
		// Character Meaning
		// , Separates multiple field selectors
		// / Field sub selector
		// ( Begin subselection expression
		// ) End subselection expression
		// Example:
		// /users?fields=id,first_name,last_name
		// This request on a user returns ID, first name, last name
		//
		// /files?fields=id,owner(id,first_name,last_name)
		// This request on a file returns ID, the owner of the file with ID, first name and last name
		//
		// /users/123?fields=id,address/street
		// This request on a user returns only the ID, the street of address.
		// Selection address/street is equivalent to address(street)
		//
		// Parameter:
		// fields : The selector string
		// -----------------------------------------------------------------------------
		if(empty($fields) || ! is_string($fields)) {
			return false;
		}

		if(static::startsWithReserved($fields)) {
			return new \ErrorException(
				'A reserved token can not be the first character of the fields selector.');
		}

		$subSelect = [];
		$nested = [];
		$currentName = '';

		$parent = new \stdClass();
		for($i = 0; $i < strlen($fields); $i ++) {
			$chr = $fields{$i};
			$child;

			if($chr === static::$selectorReservedChars['nested']) {
				$currentName = trim($currentName);

				if(strlen($currentName) == 0) {
					return new \ErrorException(
						'Nested field token \'' + static::$selectorReservedChars['nested'] +
							 '\' can not be preceeded by another reserved token');
				}

				if(! property_exists($parent, $currentName)) {
					$parent->{$currentName} = new \stdClass();
				}

				$child = $parent->{$currentName};
				$currentName = '';

				array_push($nested, $parent);
				$parent = $child;
			} else if($chr === static::$selectorReservedChars['multiple']) {
				$currentName = trim($currentName);

				if(strlen($currentName) > 0) {
					if(! property_exists($parent, $currentName)) {
						$parent->{$currentName} = new \stdClass();
					}

					$currentName = '';
				}

				while(count($nested) > 0) {
					$parent = array_pop($nested);
				}
			} else if($chr === static::$selectorReservedChars['begin_sub']) {
				$currentName = trim($currentName);

				if(strlen($currentName) == 0) {
					return new \ErrorException(
						'Begin subselection token \'' +
							 static::$selectorReservedChars['begin_sub'] +
							 '\' can not be preceeded by another reserved token');
				}

				if(! property_exists($parent, $currentName)) {
					$parent->{$currentName} = new \stdClass();
				}

				$child = $parent->{$currentName};
				$currentName = '';

				array_push($subSelect, $parent);
				$parent = $child;

				$nested = [];
			} else if($chr === static::$selectorReservedChars['end_sub']) {
				$currentName = trim($currentName);

				if(strlen($currentName) > 0) {
					if(! property_exists($parent, $currentName)) {
						$parent->{$currentName} = new \stdClass();
					}

					$currentName = '';
				}

				$parent = array_pop($subSelect);
				$nested = [];
			} else {
				$currentName .= $chr;
			}
		}

		if(count($subSelect) > 0) {
			return new \ErrorException(
				'Invalid field selection, missing end subselection.');
		}

		$currentName = trim($currentName);
		if(strlen($currentName) > 0) {
			$parent->{$currentName} = new \stdClass();
		}

		while(count($nested) > 0) {
			$parent = array_pop($nested);
		}

		return $parent;
	}
}

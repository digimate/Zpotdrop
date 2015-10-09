<?php
namespace Tedmate\ApiConnector;
class UrlBuilder
{
	
	public static function getStringParameters(array $parameters)
	{
		return static::where($parameters, function($k, $v) { return is_string($k); });
	}
	public static function getNumericParameters(array $parameters)
	{
		return static::where($parameters, function($k, $v) { return is_numeric($k); });
	}
	public static function replaceNamedParameters($path, &$parameters)
	{
		return preg_replace_callback('/\{(.*?)\??\}/', function($m) use (&$parameters)
		{
			return isset($parameters[$m[1]]) ? static::pull($parameters, $m[1]) : $m[0];

		}, $path);
	}
	public static function buildUrl( $url, $parameters = array() ) 
	{
		$url = static::replaceNamedParameters( $url ,$parameters );
		if( count($parameters) > 0 ) {
			$query = http_build_query(
				$keyed = static::getStringParameters($parameters)
			);
			if (count($keyed) < count($parameters))
			{
				$query .= '&'.implode(
					'&', self::getNumericParameters($parameters)
				);
			}
			return $url . '?'.trim($query, '&');
		}
		return $url;
	}
	public static function where($array, \Closure $callback)
	{
		$filtered = array();

		foreach ($array as $key => $value)
		{
			if (call_user_func($callback, $key, $value)) $filtered[$key] = $value;
		}

		return $filtered;
	}
	public static function pull(&$array, $key, $default = null)
	{
		$value = static::get($array, $key, $default);

		static::forget($array, $key);

		return $value;
	}
	public static function get($array, $key, $default = null)
	{
		if (is_null($key)) return $array;

		if (isset($array[$key])) return $array[$key];

		foreach (explode('.', $key) as $segment)
		{
			if ( ! is_array($array) || ! array_key_exists($segment, $array))
			{
				return value($default);
			}

			$array = $array[$segment];
		}

		return $array;
	}
	public static function forget(&$array, $keys)
	{
		$original =& $array;

		foreach ((array) $keys as $key)
		{
			$parts = explode('.', $key);

			while (count($parts) > 1)
			{
				$part = array_shift($parts);

				if (isset($array[$part]) && is_array($array[$part]))
				{
					$array =& $array[$part];
				}
			}

			unset($array[array_shift($parts)]);

			// clean up after each pass
			$array =& $original;
		}
	}

}
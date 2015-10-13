<?php
namespace App\Acme\Utils;

class Url {
	
	public static function getRootUploadDir() {
        return public_path(config('custom.upload_dir'));
    }
}
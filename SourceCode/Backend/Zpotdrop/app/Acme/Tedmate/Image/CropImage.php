<?php
namespace Tedmate\Image;

use Tedmate\Image\Thumbnail;
use Tedmate\Image\Crop;
use Tedmate\Utils\Character;
use Tedmate\Utils\Logger;

class CropImage {

    const CENTER = 'center';
    const CUSTOM = 'custom';

    /**
     * @param $base64
     * @param int $x
     * @param int $y
     * @param int $width
     * @param int $height
     * @param string $cropType (center, left, right, custom[$x, $y])
     * @param int $type
     * @return string
     */
	public static function base64($base64, $cropType = self::CENTER, $width=70, $height=70, $x = 0, $y = 0, $type=0) {
		$json = Character::base64Decrypt($base64);
		$image = self::json($json, $cropType, $width, $height, $x, $y, $type);
		return $image;
	}
	/***/
	public static function json($json, $cropType = self::CENTER, $width=70, $height=70, $x = 0, $y = 0, $type=0) {
		$image = '';
		//return $json;
		try {
			if(!empty($json)) {
				$arr = (array)@json_decode($json);
				$path = isset($arr['path']) ? $arr['path'] : '';
				$name = isset($arr['name']) ?  $arr['name'] : '';
				$ext = isset($arr['ext']) ?  $arr['ext'] : '.jpg';
				$wOrigin = isset($arr['width']) ?  $arr['width'] : 0;
				$hOrigin = isset($arr['height']) ?  $arr['height'] : 0;

                switch ($cropType) {
                    case self::CENTER:
                        $heightRatio = $hOrigin / $height;
                        $widthRatio  = $wOrigin /  $width;

                        if ($heightRatio < $widthRatio) {
                            $optimalRatio = $heightRatio;
                        } else {
                            $optimalRatio = $widthRatio;
                        }
                        $optimalHeight = $hOrigin / $optimalRatio;
                        $optimalWidth  = $wOrigin  / $optimalRatio;
                        $x = (int)($wOrigin / 2) - (int)($optimalWidth / 2);
                        $y = (int)($hOrigin / 2) - (int)($optimalHeight / 2);
//                        $x = ( $optimalWidth / 2) - ( $width /2 );
//                        $y = ( $optimalHeight/ 2) - ( $height/2 );
                        break;
                }
				$source = $path . $name . $ext;
				if($width > $wOrigin || $height > $hOrigin) {
					$target = $source;
				} else {
					$target = $path . $name . '-' . $x . 'x'. $y . '-' . $width .'x' .$height . $ext;
				}				
				if(file_exists(UPLOAD_DIR . '/' . $source)) {
					if(!file_exists(UPLOAD_DIR . '/' . $target)  ) {
                        if (Crop::cropImage(UPLOAD_DIR . '/' . $source, UPLOAD_DIR . '/' . $target, $x, $y, $width, $height)) {
                            $image = $target;
                        } else {
                            $image = '';
                        }
					}else {
						$image = $target;
					}
				} else {
					$image = '';
				}
				
			} else {
				$image = '';
			}
			
		} catch(\Exception $e) {
			$image = '';
		}
		
		if(empty($image)) {
			if($type == 1) {
				$image = 'default/no-avatar.png';
			} else {
				$image = 'default/cover.jpg';
			}
		}
		return $image;
	}



    public static function crop($json, $width=70, $height=70, $x = 0, $y = 0) {
        $image = '';
        //return $json;
        try {
            Logger::begin('CropImage:crop');
            Logger::params(['json' => $json, 'x' => $x, 'y'=> $y, 'width' => $width, 'height' => $height ]);
            if(!empty($json)) {
                $arr = (array)@json_decode($json);
                $path = isset($arr['path']) ? $arr['path'] : '';
                $name = isset($arr['name']) ?  $arr['name'] : '';
                $ext = isset($arr['ext']) ?  $arr['ext'] : '.jpg';
                $wOrigin = isset($arr['width']) ?  $arr['width'] : 0;
                $hOrigin = isset($arr['height']) ?  $arr['height'] : 0;


                $source = $path . $name . $ext;
                if (!file_exists(UPLOAD_DIR . DIRECTORY_SEPARATOR . $source)) {
                    return [
                        'error' => 1,
                        'message' => 'File is not exist'
                    ];
                }

                $cropName = $name . '-' . $x . 'x'. $y . '-' . $width .'x' .$height;
                if($width > $wOrigin || $height > $hOrigin) {
                    return [
                        'error' => 0,
                        'data' => [
                            'json' => $json,
                            'base64' => Character::base64Encrypt($json)
                        ]
                    ];
                } else {
                    $target = $path . $cropName . $ext;
                }
                if (file_exists(UPLOAD_DIR . DIRECTORY_SEPARATOR . $target) ||
                    Crop::cropImage(UPLOAD_DIR . DIRECTORY_SEPARATOR . $source, UPLOAD_DIR . DIRECTORY_SEPARATOR . $target, $x, $y, $width, $height)) {
                    $data = Character::stripTags(@json_encode([
                        'path' => $path,
                        'name' => $cropName,
                        'ext' => $ext,
                        'width' => $width,
                        'height' => $height,
                        'alt_name' => isset($arr['alt_name']) ? $arr['alt_name'] : ''
                    ]));


                    return [
                        'error' => 0,
                        'data' => [
                            'json' => $data,
                            'base64' => Character::base64Encrypt($data)
                        ]
                    ];
                } else {
                    Logger::finish('CropImage:crop:CropImage:False');
                }

            } else {
                Logger::finish('CropImage:crop:EmptyJson');
            }

        } catch(\Exception $e) {
            Logger::finish('CropImage:crop:Exception', $e);
        }

        return [
            'error' => 1,
            'message' => 'File is not exist'
        ];
    }
}
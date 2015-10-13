<?php
namespace App\Acme\Utils\Image;

use App\Acme\Utils\Url;
use App\Acme\Utils\Image\Thumbnail;
use App\Acme\Utils\Image\Crop;
use App\Acme\Utils\Character;

class ResizeImage {

	/**
	* Resize image from string base64 encrypt
	* @param string $base64
	* @param int $width
	* @param int $height
	* @param int $type: value options [0: normal, 1: avatar]
	* @return string path
	*/
	public static function base64($base64, $width=70, $height=70, $type='avatar') {
		$json = Character::base64Decrypt($base64);
		$image = self::json($json, $width, $height, $type);
		return $image;
	}
	/***/
	public static function json($json, $width, $height, $type = 'avatar') {
		$image = '';
        $uploadDir = Url::getRootUploadDir();
		//return $json;
		try {
			if(!empty($json)) {
				$arr = (array)@json_decode($json);
				$path = isset($arr['path']) ? $arr['path'] : '';
				$name = isset($arr['name']) ?  $arr['name'] : '';
				$ext = isset($arr['ext']) ?  $arr['ext'] : '.jpg';
				$wOrigin = isset($arr['width']) ?  $arr['width'] : 0;
				$hOrigin = isset($arr['height']) ?  $arr['height'] : 0;
				
				$source = $path . $name . $ext;
				if($width > $wOrigin || $height > $hOrigin) {
					$target = $source;
				} else {
					$target = $path . $name . '-' . $width .'x' .$height . $ext;
				}				
				if(file_exists($uploadDir . '/' . $source)) {
					if(!file_exists($uploadDir . '/' . $target)  ) {
					
						if($width == $height) {							
							if(Crop::square($uploadDir . '/' . $source, $uploadDir . '/' . $target, $width, $width)) {
								$image = $target;
							} else {
								$image = '';
							}
						} else {
						
							$thumb = new Thumbnail($uploadDir . '/' . $source);
							
							if($width > 0 && $height==0) {
								$thumb->size_width($width);
							}elseif($width == 0 && $height > 0) {
								$thumb->size_height($height);
							}else {
								$thumb->size($width,$height);
							}
							$thumb->quality=100;                        
							$thumb->jpeg_progressive=0;  
							$thumb->allow_enlarge=false; 
							$thumb->process(); 
							$thumb->save($uploadDir . '/' . $target);
							if(empty($thumb->error_msg)) {
								$image = $target;
							} else {
								$image = '';
							}
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
			
		} catch(Exception $e) {
			$image = '';
		}
		
		if(empty($image)) {
            switch($type) {
                case 'avatar':
                    $image = 'default/no-avatar.png';
                    break;
                default:
                    $image = 'default/no-avatar.png';
            }
		}
		return $image;
	}

    public static function json_thumb($json, $width, $height, $type='avatar') {
        $image = '';
        $uploadDir = Url::getRootUploadDir();
        //return $json;
        try {
            if(!empty($json)) {
                $arr = (array)@json_decode($json);
                $path = isset($arr['path']) ? $arr['path'] : '';
                $name = isset($arr['name']) ?  $arr['name'] : '';
                $ext = isset($arr['ext']) ?  $arr['ext'] : '.jpg';
                $wOrigin = isset($arr['width']) ?  $arr['width'] : 0;
                $hOrigin = isset($arr['height']) ?  $arr['height'] : 0;

                $source = $path . $name . $ext;
                if($width > $wOrigin || $height > $hOrigin) {
                    $target = $source;
                } else {
                    $target = $path . $name . 'thumb -' . $width .'x' .$height . $ext;
                    $tmp = $path . $name . 'tmp -' . $width .'x' .$height . $ext;
                }
                if(file_exists($uploadDir . '/' . $source)) {
                    if(!file_exists($uploadDir . '/' . $target)  ) {

                        if($width == $height) {
                            if(Crop::square($uploadDir . '/' . $source, $uploadDir . '/' . $target, $width, $width)) {
                                $image = $target;
                            } else {
                                $image = '';
                            }
                        } else {

                            $thumb = new Thumbnail($uploadDir . '/' . $source);

                            $heightRatio = $hOrigin / $height;
                            $widthRatio  = $wOrigin /  $width;

                            if ($heightRatio < $widthRatio) {
                                $optimalRatio = $heightRatio;
                            } else {
                                $optimalRatio = $widthRatio;
                            }
                            $newHeight = $hOrigin / $optimalRatio;
                            $newWidth  = $wOrigin  / $optimalRatio;

                            $thumb->size($newWidth,$newHeight);

                            $thumb->quality=100;
                            $thumb->jpeg_progressive=0;
                            $thumb->allow_enlarge=false;
                            $thumb->process();
                            $thumb->save($uploadDir . '/' . $tmp);
                            if(empty($thumb->error_msg)) {
                                $imageSize = getimagesize($uploadDir . '/' . $tmp);
                                if ($imageSize[0] <= $width && $imageSize[1] <= $height) {
                                    $image = $tmp;
                                } else {
                                    if (Crop::cropImage($uploadDir . '/' . $tmp, $uploadDir . '/' . $target, 0, 0, $width, $height)) {
                                        $image = $target;
                                    } else {
                                        $image = '';
                                    }
                                }

                            } else {
                                $image = '';
                            }
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

        } catch(Exception $e) {
            $image = '';
        }

        if(empty($image)) {
            switch($type) {
                case 'avatar':
                    $image = 'default/no-avatar.png';
                    break;
                default:
                    $image = 'default/no-avatar.png';
            }
        }
        return $image;
    }
}
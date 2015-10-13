<?php

namespace App\Acme\Utils\Image;

define('DESIRED_IMAGE_WIDTH', 130);
define('DESIRED_IMAGE_HEIGHT', 130);

class Crop {
	//----------------------------------------------------------------
	// Crop-to-fit PHP-GD
	// Revision 2 [2009-06-01]
	// Corrected aspect ratio of the output image
	//----------------------------------------------------------------

  
	public static function square($srcFile, $dstFile, $width=DESIRED_IMAGE_WIDTH, $height=DESIRED_IMAGE_HEIGHT) {		
		//
		// Add file validation code here
		//
    
		list( $srcWidth, $srcHeight, $srcType ) = getimagesize( $srcFile );
		
		switch ( $srcType )
		{
			case IMAGETYPE_GIF:
				$srcGdim = imagecreatefromgif( $srcFile );
				break;

			case IMAGETYPE_JPEG:
				$srcGdim = imagecreatefromjpeg( $srcFile );
				break;

			case IMAGETYPE_PNG:
				$srcGdim = imagecreatefrompng( $srcFile );
				break;
		}
		if(!$srcGdim)
			return false;
			
		$srcAspectRatio = $srcWidth / $srcHeight;
		$dstAspectRatio = $width / $height;
		
		if ( $srcAspectRatio > $dstAspectRatio )
		{
			//
			// Triggered when source image is wider
			//
			$tmpHeight = $height;
			$tmpWidth = ( int ) ( $height * $srcAspectRatio );
		}
		else
		{
			//
			// Triggered otherwise (i.e. source image is similar or taller)
			//
			$tmpWidth = $width;
			$tmpHeight = ( int ) ( $width / $srcAspectRatio );
		}

		//
		// Resize the image into a temporary GD image
		//
		$tmpGdim = imagecreatetruecolor( $tmpWidth, $tmpHeight );
		imagecopyresampled(
							$tmpGdim,
							$srcGdim,
							0, 0,
							0, 0,
							$tmpWidth, $tmpHeight,
							$srcWidth, $srcHeight
						);

		//
		// Copy cropped region from temporary image into the desired GD image
		//

		$x0 = ( $tmpWidth - $width ) / 2;
		$y0 = ( $tmpHeight - $height ) / 2;

		$dstGdim = imagecreatetruecolor( $width, $height );
		imagecopy(
					$dstGdim,
					$tmpGdim,
					0, 0,
					$x0, $y0,
					$width, $height
		);

		//
		// Render the image
		// Alternatively, you can save the image in file-system or database
		//
		//header( 'Content-type: image/jpeg' );
		imagejpeg( $dstGdim, $dstFile, 100);
		imagedestroy ( $srcGdim );
		imagedestroy ( $dstGdim );
		//
		// Add clean-up code here
		//
		return true;
	}
	
	public static function cropImage($src_file, $target_file, $x, $y, $width, $height)
   	{
		list($width_orig, $height_orig, $type) = getimagesize($src_file);

		if ($width_orig == 0 || $height_orig == 0) {
			return false;
		}
     
		if ($type == IMG_JPG) {
			$image = @imagecreatefromjpeg($src_file);
		}
		else if ($type == IMG_PNG || $type == 3) { // php bug seemingly..
			$image = @imagecreatefrompng($src_file);
		}
		else if ($type == IMG_GIF) {
			$image = @imagecreatefromgif($src_file);
		}
		else {
			return false;
		}
		if (!$image) {
			return false;
		}
		$x = abs(intval($x));
		$y = abs(intval($y));
		$width = abs(intval($width));
		$height = abs(intval($height));
     
		if ( $width == 0 || $height == 0 || (($x + $width) > $width_orig) || (($y + $height) > $height_orig) ) {
			return false;
		}
     
		$image_p = imagecreatetruecolor($width, $height);
		if ( !imagecopy($image_p, $image, 0, 0, $x, $y, $width, $height) ) {
			return false;
		}
		return imagejpeg($image_p, $target_file, 100);
   	}
	
	function thumbCover($srcFile, $dstFile,$x0,$y0,$width=DESIRED_IMAGE_WIDTH, $height=DESIRED_IMAGE_HEIGHT) {		
		//
		// Add file validation code here
		//

		list( $srcWidth, $srcHeight, $srcType ) = getimagesize( $srcFile );
		
		switch ( $srcType )
		{
			case IMAGETYPE_GIF:
				$srcGdim = imagecreatefromgif( $srcFile );
				break;

			case IMAGETYPE_JPEG:
				$srcGdim = imagecreatefromjpeg( $srcFile );
				break;

			case IMAGETYPE_PNG:
				$srcGdim = imagecreatefrompng( $srcFile );
				break;
		}
		if(!$srcGdim)
			return false;
		$srcAspectRatio = $srcWidth / $srcHeight;
		$dstAspectRatio = $width / $height;
		if ( $srcAspectRatio > $dstAspectRatio )
		{
			//
			// Triggered when source image is wider
			//
			$tmpHeight = $height;
			$tmpWidth = ( int ) ( $height * $srcAspectRatio );
		}
		else
		{
			//
			// Triggered otherwise (i.e. source image is similar or taller)
			//
			$tmpWidth = $width;
			$tmpHeight = ( int ) ( $width / $srcAspectRatio );
		}

		//
		// Resize the image into a temporary GD image
		//
		$tmpGdim = imagecreatetruecolor( $srcWidth, $srcHeight );
		imagecopyresampled(
							$tmpGdim,
							$srcGdim,
							0, 0,
							0, 0,
							$tmpWidth, $tmpHeight,
							$srcWidth, $srcHeight
						);

		//
		// Copy cropped region from temporary image into the desired GD image
		//

		/*$x0 = ( $tmpWidth - $width ) / 2;
		$y0 = ( $tmpHeight - $height ) / 2;*/

		$dstGdim = imagecreatetruecolor( $width, $height );
		imagecopy(
					$dstGdim,
					$tmpGdim,
					0, 0,
					$x0, $y0,
					$width, $height
		);

		//
		// Render the image
		// Alternatively, you can save the image in file-system or database
		//
		//header( 'Content-type: image/jpeg' );
		imagejpeg( $dstGdim, $dstFile, 100);
		imagedestroy ( $srcGdim );
		imagedestroy ( $dstGdim );
		//
		// Add clean-up code here
		//
		return true;
	}
}

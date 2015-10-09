<?php
/**
 * Process image (crop, resize)
 * Reference : http://phpimagemagician.jarrodoberto.com/
 * User: nhieunguyen
 * Date: 22/06/2015
 * Time: 13:08
 */
namespace Tedmate\Image;

class Image
{
    private $image;
    private $width;
    private $height;
    private $extension;
    private $imageResized;
//    private $transparentArray = array('png', 'gif');
//    private $keepTransparency = true;
//    private $fillColorArray = array('r'=>255, 'g'=>255, 'b'=>255);


    public function __construct($file)
    {
        $this->image = $this->loadImage($file);
        $this->width = imagesx($this->image);
        $this->height = imagesy($this->image);
    }

    /**
     * Crop image from center
     *
     * @param $newWidth
     * @param $newHeight
     * @param $desPath
     */
    public function cropImage($newWidth, $newHeight, $desPath)
    {
        $this->imageResized = $this->image;
        $this->crop($this->width, $this->height, $newWidth, $newHeight);
        $this->saveImage($desPath);
    }

    /**
     * @param $newWidth
     * @param $newHeight
     * @param $desPath
     * @param string $option :
     *                          exact = defined size;
    portrait = keep aspect set height;
    landscape = keep aspect set width;
    auto = auto;
    crop= resize and crop;
     */
    public function resize($newWidth, $newHeight, $desPath, $option = 'auto')
    {
        // *** Get optimal width and height - based on $option
        $dimensionsArray = $this->getDimensions($newWidth, $newHeight, $option);

        $optimalWidth  = $dimensionsArray['optimalWidth'];
        $optimalHeight = $dimensionsArray['optimalHeight'];

        // *** Resample - create image canvas of x, y size
        $this->imageResized = imagecreatetruecolor($optimalWidth, $optimalHeight);
//        $this->keepTransparancy($optimalWidth, $optimalHeight, $this->imageResized);
        imagecopyresampled($this->imageResized, $this->image, 0, 0, 0, 0, $optimalWidth, $optimalHeight, $this->width, $this->height);

        if ($option === 'crop')
        {
            if (($optimalWidth >= $newWidth && $optimalHeight >= $newHeight)) {
                $this->crop($optimalWidth, $optimalHeight, $newWidth, $newHeight);
            }
        }
        $this->saveImage($desPath);

    }


    private function loadImage($file)
    {
        $this->extension = strtolower(pathinfo($file, PATHINFO_EXTENSION)) ;
        switch ($this->extension)
        {
            case 'jpg':
            case 'jpeg':
                $image = @imagecreatefromjpeg($file);
                break;
            case 'png':
                $image = @imagecreatefrompng($file);
                break;
            case 'gif':
                $image = @imagecreatefromgif($file);
                break;
            default:
                $image = null;
                break;

        }
        return $image;
    }

    /**
     * Keep transparency for png and gif image
     *
     * @param $width
     * @param $height
     * @param $im
     */
    private function keepTransparancy($width, $height, $im)
    {
        // *** If PNG, perform some transparency retention actions (gif untested)
        if (in_array($this->extension, $this->transparentArray) && $this->keepTransparency) {
            imagealphablending($im, false);
            imagesavealpha($im, true);
            $transparent = imagecolorallocatealpha($im, 255, 255, 255, 127);
            imagefilledrectangle($im, 0, 0, $width, $height, $transparent);
        } else {
            $color = imagecolorallocate($im, $this->fillColorArray['r'], $this->fillColorArray['g'], $this->fillColorArray['b']);
            imagefilledrectangle($im, 0, 0, $width, $height, $color);
        }
    }

    /**
     * Get new image dimensions based on user specificaions
     * @param $newWidth
     * @param $newHeight
     * @param $option
     * @return array
     *
     * Notes:    If $option = auto then this function is call recursivly
    #
    #       To clarify the $option input:
    #               exact = The exact height and width dimensions you set.
    #               portrait = Whatever height is passed in will be the height that
    #                   is set. The width will be calculated and set automatically
    #                   to a the value that keeps the original aspect ratio.
    #               landscape = The same but based on the width.
    #               auto = Depending whether the image is landscape or portrait, this
    #                   will automatically determine whether to resize via
    #                   dimension 1,2 or 0.
    #               crop = Resize the image as much as possible, then crop the
    #         remainder.
     */
    private function getDimensions($newWidth, $newHeight, $option)
    {
        switch ($option)
        {
            case 'exact':
                $optimalWidth = $newWidth;
                $optimalHeight= $newHeight;
                break;
            case 'portrait':
                $optimalWidth = $this->getSizeByFixedHeight($newWidth, $newHeight);
                $optimalHeight = $newHeight;
                break;
            case 'landscape':
                $optimalWidth = $newWidth;
                $optimalHeight = $this->getSizeByFixedWidth($newWidth, $newHeight);
                break;
            case 'auto':
                $dimensionsArray = $this->getSizeByAuto($newWidth, $newHeight);
                $optimalWidth = $dimensionsArray['optimalWidth'];
                $optimalHeight = $dimensionsArray['optimalHeight'];
                break;
            case 'crop':
                $dimensionsArray = $this->getOptimalCrop($newWidth, $newHeight);
                $optimalWidth = $dimensionsArray['optimalWidth'];
                $optimalHeight = $dimensionsArray['optimalHeight'];
                break;
        }

        return array('optimalWidth' => $optimalWidth, 'optimalHeight' => $optimalHeight);
    }

    ## --------------------------------------------------------

    private function getSizeByFixedHeight($newWidth, $newHeight)
    {
        $ratio = $this->width / $this->height;
        //return $newWidth;
        return $newHeight * $ratio;
    }

## --------------------------------------------------------

    private function getSizeByFixedWidth($newWidth, $newHeight)
    {
        $ratio = $this->height / $this->width;
        //return $newHeight;
        return $newWidth * $ratio;
    }

    ## --------------------------------------------------------

    private function getSizeByAuto($newWidth, $newHeight)
    {
        if ($this->height < $this->width)
        {// *** Image to be resized is wider (landscape)
            $optimalWidth = $newWidth;
            $optimalHeight= $this->getSizeByFixedWidth($newWidth, $newHeight);
        } elseif ($this->height > $this->width)
        {// *** Image to be resized is taller (portrait)

            $optimalWidth =  $this->getSizeByFixedHeight($newWidth, $newHeight);
            $optimalHeight = $newHeight;
        } else
        {
            if ($newHeight < $newWidth) {
                $optimalWidth = $newWidth;
                $optimalHeight = $this->getSizeByFixedWidth($newWidth, $newHeight);
            } else if ($newHeight > $newWidth) {
                $optimalWidth = $this->getSizeByFixedHeight($newWidth, $newHeight);
                $optimalHeight = $newHeight;
            } else
            {
                // *** Sqaure being resized to a square
                $optimalWidth = $newWidth;
                $optimalHeight= $newHeight;
            }
        }

        return array('optimalWidth' => $optimalWidth, 'optimalHeight' => $optimalHeight);
    }


    /**
     * @param $optimalWidth
     * @param $optimalHeight
     * @param $newWidth
     * @param $newHeight
     */
    private function crop($optimalWidth, $optimalHeight, $newWidth, $newHeight)
    {

        // *** Get cropping co-ordinates
        // current only crop from center
        $cropStartX = ( $optimalWidth / 2) - ( $newWidth /2 );
        $cropStartY = ( $optimalHeight/ 2) - ( $newHeight/2 );

        // *** Crop this bad boy
        $crop = imagecreatetruecolor($newWidth , $newHeight);
        //$this->keepTransparancy($optimalWidth, $optimalHeight, $crop);
        imagecopyresampled($crop, $this->imageResized, 0, 0, $cropStartX, $cropStartY, $newWidth, $newHeight , $newWidth, $newHeight);

        $this->imageResized = $crop;

        // *** Set new width and height to our variables
        $this->width = $newWidth;
        $this->height = $newHeight;

    }

    /**
     * Saves the image
     *
     * @param $savePath : Where to save the image including filename
     * @param string $imageQuality : image quality you want the image saved at 0-100
     * Notes:    * gif doesn't have a quality parameter
     *           * jpg has a quality setting 0-100 (100 being the best)
     *           * png has a quality setting 0-9 (0 being the best).
     */
    private function saveImage($savePath, $imageQuality="100")
    {
        switch($this->extension)
        {
            case 'jpg':
            case 'jpeg':
                if (imagetypes() & IMG_JPG)
                {
                    imagejpeg($this->imageResized, $savePath, $imageQuality);
                }
                break;

            case 'gif':
                if (imagetypes() & IMG_GIF)
                {
                    imagegif($this->imageResized, $savePath);
                }
                break;

            case 'png':
                // *** Scale quality from 0-100 to 0-9
                $scaleQuality = round(($imageQuality/100) * 9);

                // *** Invert qualit setting as 0 is best, not 9
                $invertScaleQuality = 0;// 9 - $scaleQuality;
                if (imagetypes() & IMG_PNG)
                {
                    imagepng($this->imageResized, $savePath, $invertScaleQuality);
                }
                break;

            default:
                break;
        }
        imagedestroy($this->imageResized);
    }

    /**
     * Get optimal crop dimensions
     *
     * @param $newWidth
     * @param $newHeight
     * @return array
     *  Notes:      The optimal width and height return are not the same as the
    #       same as the width and height passed in. For example:
    #
    #
    #   |-----------------|     |------------|       |-------|
    #   |             |   =>  |**|      |**|   =>  |       |
    #   |             |     |**|      |**|       |       |
    #   |           |       |------------|       |-------|
    #   |-----------------|
    #        original                optimal             crop
    #              size                   size               size
    #  Fig          1                      2                  3
    #
    #       300 x 250           150 x 125          150 x 100
    #
    #    The optimal size is the smallest size (that is closest to the crop size)
    #    while retaining proportion/ratio.
    #
    #  The crop size is the optimal size that has been cropped on one axis to
    #  make the image the exact size specified by the user.
    #
    #               * represent cropped area
     */
    private function getOptimalCrop($newWidth, $newHeight)
    {
        $heightRatio = $this->height / $newHeight;
        $widthRatio  = $this->width /  $newWidth;

        if ($heightRatio < $widthRatio) {
            $optimalRatio = $heightRatio;
        } else {
            $optimalRatio = $widthRatio;
        }

        $optimalHeight = $this->height / $optimalRatio;
        $optimalWidth  = $this->width  / $optimalRatio;

        return array('optimalWidth' => $optimalWidth, 'optimalHeight' => $optimalHeight);
    }

}
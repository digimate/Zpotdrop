<?php
/**
 * Created by PhpStorm.
 * User: Nhieu Nguyen
 * Date: 10/8/2015
 * Time: 18:20
 */

namespace App\Acme\Utils;


class Time
{
    /**
     * @return \DateTime
     */
    public static function getDateTime()
    {
        return new \DateTime();
    }

    /**
     * @param   string strDate (string date : format=Y-m-d, if null will get current date)
     * @return \DateTime
     */
    public static function getStartDay($strDate = null)
    {
        if ($strDate === null) {
            $strDate = date('Y-m-d');
        }
        return new \DateTime(date("{$strDate} 00:00:00"));
    }

    /**
     * @param   string strDate (string date : format=Y-m-d, if null will get current date)
     * @return \DateTime
     */
    public static function getEndDay($strDate = null)
    {
        if ($strDate === null) {
            $strDate = date('Y-m-d');
        }
        return new \DateTime(date("{$strDate} 23:59:59"));
    }

    /**
     * @return \DateTime
     */
    public static function getStartNextNDay($n)
    {
        return date_add(self::getStartDay(), date_interval_create_from_date_string("{$n} days"));

    }

    /**
     * @return \DateTime
     */
    public static function getEndNextNDay($n)
    {
        return date_add(self::getEndDay(), date_interval_create_from_date_string("{$n} days"));
    }

    public static function max(\DateTime $date1, \DateTime $date2)
    {
        //invert: Is 1 if the interval represents a negative time period and 0 otherwise.
        if ($date1->getTimestamp() < $date2->getTimestamp() )
        {
            return $date2;
        }
        return $date1;
    }
}
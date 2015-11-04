<?php
/**
 * Created by PhpStorm.
 * User: Nhieu Nguyen
 * Date: 11/3/2015
 * Time: 16:04
 */

namespace app\Acme\Collections;


use Fadion\Bouncy\BouncyCollectionTrait;
use Illuminate\Database\Eloquent\Collection;

/**
 * Class ElasticCollection use for elastic document has parent
 * @package app\Acme\Collections
 */
class ElasticCollection extends Collection {

    use BouncyCollectionTrait;

    /**
     * Indexes all the results from the
     * collection.
     *
     * @return array
     */
    public function index()
    {
        if ($this->isEmpty()) {
            return false;
        }

        $params = array();
        foreach ($this->all() as $item) {
            $parentColumn = $item->getParentKey();
            $params['body'][] = array(
                'index' => array(
                    '_index' => $item->getIndex(),
                    '_type' => $item->getTypeName(),
                    '_id' => $item->getKey(),
                    'parent' => (string)$item->$parentColumn
                )
            );
            $params['body'][] = $item->documentFields();
        }

        return $this->getElasticClient()->bulk($params);
    }

}
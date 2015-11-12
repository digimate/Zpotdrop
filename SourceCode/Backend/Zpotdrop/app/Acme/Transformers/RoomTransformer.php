<?php

namespace App\Acme\Transformers;
use App\Acme\Models\Comment;


/**
 * Class RoomTransformer
 * @package App\Models\Transformers
 */
class RoomTransformer extends Transformer
{

	/**
	 * List of resources possible to include
	 *
	 * @var array
	 */
	protected $availableIncludes = [];

	/**
	 * @var array
	 */
	protected $defaultIncludes = [];

	/**
	 * UserTransformer constructor.
	 */
	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Turn this item object into a generic array
	 *
	 * @return array
	 */
	public function transform($room)
	{
		$arrPost = $room->toArray();
		return $arrPost;
	}

}
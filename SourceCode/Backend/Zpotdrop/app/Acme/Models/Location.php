<?php
/*
|--------------------------------------------------------------------------
| BaseModel.php
|--------------------------------------------------------------------------
| @Author     : John Nguyen
| @Email      : pisun2@gmail.com
| @Copyright  : © 2015 LeapZone.
| @Date       : 7/26/15 - 1:32 PM
*/

namespace App\Acme\Models;
use Fadion\Bouncy\BouncyTrait;

/**
 * App\Models\Friend
 *
 */
class Location extends BaseModel
{
    use BouncyTrait;
	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'locations';

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable = ['name', 'address', 'lat', 'long', 'user_id'];

    protected $mappingProperties = array(
        "geo_point" => [
            "type" => "geo_point",
            "analyzer" => "stop",
            "stopwords" => [","]
        ]
    );

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['created_at', 'deleted_at', 'updated_at', 'geo_point', 'user_id'];

    public static $rule = [
        'lat'           => 'required|numeric',
        'long'          => 'required|numeric',
        'name'          => 'required|max:255',
        'address'       => 'required|max:255'
    ];

    /**
     * Save the model to the database.
     *
     * @param  array  $options
     * @return bool
     */
    public function save(array $options = [])
    {
        $this->setAttribute('geo_point', "{$this->getAttribute('lat')}, {$this->getAttribute('long')}" );
        return parent::save($options);
    }


    public static function getLocations($keyword, $distance, $lat, $long, $page, $limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);
        $offset = ($page - 1) * $limit;
        $distance = self::getDistance($distance);

        $params = [
            'query' => [
                "filtered" => [
                    'filter' => [
                        'geo_distance' => [
                            "distance" => "{$distance}km",
                            "geo_point" => [
                                'lat' => $lat,
                                'lon' => $long
                            ]
                        ]
                    ], // and
                    /*'query' => [
                        'match' => [
                            'title' => '',
                        ]
                    ]*/
                ]
            ],
            "sort" => [[
                "_geo_distance" => [
                    "geo_point" => [
                        "lat" =>  $lat,
                        "lon" => $long
                    ],
                    "order" =>         "asc",
                    "unit" =>          "km",
                    "distance_type" => "plane"
                ]
            ]],
            'from' => $offset,
            'size' => $limit
        ];

        if (!empty($keyword)) {
            $params['query']['filtered']['query'] = [
                'multi_match' => [
                    'query' => $keyword,
                    'fields' => ['name', 'address']
                ]
            ];
        }

        $results = self::search($params);
        return $results;
    }
}

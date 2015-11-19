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
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Pagination\Paginator;

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
        'id' => [
            'type' => 'long',
            'analyzer' => 'standard'
        ],
        'name' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'address' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'lat' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        'long' => [
            'type' => 'string',
            'analyzer' => 'standard'
        ],
        "geo_point" => [
            "type" => "geo_point",
            "analyzer" => "stop",
            "stopwords" => [","]
        ]
    );
    public function documentFields()
    {
        return [
            'id' => $this->id,
            'geo_point' => $this->lat . ", " . $this->long,
            'name' => $this->name,
            'address' => $this->address,
            'lat' => $this->lat,
            'long' => $this->long
        ];
    }

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = ['deleted_at', 'updated_at', 'geo_point', 'user_id'];

    public static $rule = [
        'lat'           => 'required|numeric',
        'long'          => 'required|numeric',
        'name'          => 'required|max:255',
        'address'       => 'required|max:255'
    ];

    /**
     * Save the model to the database.
     * neu override save, can phai override ke thua ham save trong BouncyTrait
     * @param  array  $options
     * @return bool
     */
   /* public function save(array $options = [])
    {
        return parent::save($options);
    }*/


    public static function getLocations($keyword, $distance, $lat, $long, &$page, &$limit) {
        $page = self::getPage($page);
        $limit = self::getLimit($limit);
        $offset = ($page - 1) * $limit;
        $distance = self::getDistance($distance);

       /* $params = [
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
                    ],
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
                    'fields' => ['name', 'address'],
                    "fuzziness" => "AUTO"
                ]
            ];
        }
        $results = self::search($params);
        */

        $distanceQr = self::getGeoDistanceQuery($lat, $long);
        $query = Location::select('locations.*', \DB::raw("{$distanceQr} AS distance"));

        if (!empty($keyword)) {
            $query->where(function($q) use ($keyword) {
                $q->orWhere('name', 'like', "%{$keyword}%");
                $q->orWhere('address', 'like', "%{$keyword}%");
            });
        }

        $query->having('distance', '<=', $distance);

        //count
        $queryCount = clone($query);
        $results = $queryCount->select(\DB::raw("{$distanceQr} AS distance, count(*) as count_number"))->get();
        $results = $results->toArray();
        $total = isset($results[0]) ? (int) array_change_key_case((array) $results[0])['count_number'] : 0;
        unset($queryCount);

        $results = [];

        if ($total > 0) {
            $query->orderBy('distance', 'asc');
            $query->orderBy('name', 'asc');
            $query->limit($limit);
            $query->offset($offset);
            $results = $query->get();
            $results = $results->all();
        }


        return new LengthAwarePaginator($results, $total, $limit, $page, [
            'path' => Paginator::resolveCurrentPath(),
            'pageName' => 'page',
        ]);

    }
}

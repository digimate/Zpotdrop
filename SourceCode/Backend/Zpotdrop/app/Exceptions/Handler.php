<?php

namespace App\Exceptions;

use App\Acme\Restful\LZResponse;
use Exception;
use League\OAuth2\Server\Exception\AccessDeniedException;
use League\OAuth2\Server\Exception\InvalidCredentialsException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that should not be reported.
     *
     * @var array
     */
    protected $dontReport = [
        HttpException::class,
    ];

    /**
     * Report or log an exception.
     *
     * This is a great spot to send exceptions to Sentry, Bugsnag, etc.
     *
     * @param  \Exception  $e
     * @return void
     */
    public function report(Exception $e)
    {
        return parent::report($e);
    }

    /**
     * Render an exception into an HTTP response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Exception  $e
     * @return \Illuminate\Http\Response
     */
    public function render($request, Exception $e)
    {throw $e;
        if ($request->is('api/*')) {
            $lzResponse = new LZResponse();
            if ($e instanceof AccessDeniedException) {
                $lzResponse->setMessage($e->getMessage());
                $lzResponse->setCode(LZResponse::HTTP_UNAUTHORIZED);
                return $lzResponse->json();
            } elseif ($e instanceof InvalidCredentialsException) {
                $lzResponse->setMessage($e->getMessage());
                $lzResponse->setCode(LZResponse::HTTP_UNAUTHORIZED);
                return $lzResponse->json();
            } else {
                \Log::error($e->getMessage(), $e->getTrace());
                throw $e;
                return $lzResponse->error(500, $e->getMessage());
            }
        }
        return parent::render($request, $e);
    }
}

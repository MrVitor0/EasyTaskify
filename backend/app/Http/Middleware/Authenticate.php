<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    /**
     * @deprecated Check /app/Exceptions/Handler.php for the unauthenticated method
     * @param  \Illuminate\Http\Request  $request
     * @return string|null
     */
    protected function redirectTo($request)
    {
        /**if (! $request->expectsJson()) {
            return route('login');
        } */
    }
}

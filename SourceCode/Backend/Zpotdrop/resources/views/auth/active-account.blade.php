@extends('mobile.master')
@section('title', 'Message')@stop

@section('content')
    <div class="header text-center">
        @if($error == 0)
            <h4 class="text-capitalize text-success">
                {{ $message }}
            </h4>
        @else
            <h4 class="text-capitalize text-danger">
                {{ $message }}
            </h4>
        @endif
    </div>
@stop
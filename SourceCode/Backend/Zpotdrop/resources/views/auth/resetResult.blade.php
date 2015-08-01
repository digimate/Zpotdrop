@extends('mobile.master')
@section('title', 'Message')@stop

@section('content')
    <div class="header text-center">
        @if(!empty($message))
            <h4 class="text-capitalize text-success">
                {{ $message }}
            </h4>
        @endif
        @if(!empty($email))
            <h4 class="text-capitalize text-danger">
                {{ $email }}
            </h4>
        @endif
    </div>
@stop
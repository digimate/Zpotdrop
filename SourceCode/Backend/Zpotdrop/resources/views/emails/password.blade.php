@extends('mobile.master')

@section('content')
    <h4 class="text-info">Password Reset</h4>

    <div>
        To reset your password, complete this form:
        <a href="{{ URL::route('oauth.password.get.reset', [$token]) }}">Click Here</a>
    </div>
@endsection
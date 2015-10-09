@extends('mobile.master')

@section('content')
    <h4 class="text-info">Confirm Email</h4>

    <div>
        Hi <b>{{$user->first_name . ' ' . $user->last_name}}</b> ! To complete your register, complete this form:
        <a href="{{ URL::route('frontend.register.verify', [$code->code]) }}">Click Here</a>
    </div>
@endsection
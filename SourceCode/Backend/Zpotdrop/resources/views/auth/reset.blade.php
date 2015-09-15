@extends('mobile.master')

@section('title', 'Reset Password')

@section('content')
    <div class="header text-center">
        <h3 class="text-capitalize text-info">
            {!! Form::label('title', 'Reset Password', ['class' => 'control-label'])
        !!}
        </h3>
    </div>
    {!! Form::open([
    'route' => ['oauth.password.post.reset'],
    'method' => 'post',
    'files'=>true]) !!}
    {!! Form::hidden('token', $token) !!}
    <div class="form-group">
        {!! Form::label('Email:') !!}
        {!! Form::input('email', 'email', Input::old('email'), [
        'placeholder'=>'Type your email',
        'class'=>'form-control',
        'required'=>'required']) !!}
    </div>
    <div class="form-group">
        {!! Form::label('Password:') !!}
        {!! Form::input('password', 'password', null, [
        'placeholder'=>'Type your passowrd',
        'class'=>'form-control',
        'required'=>'required']) !!}
    </div>
    <div class="form-group">
        {!! Form::label('Password Confirm:') !!}
        {!! Form::input('password', 'password_confirmation', null, [
        'placeholder'=>'Type your passowrd',
        'class'=>'form-control',
        'required'=>'required']) !!}
    </div>
    <div class="bottom text-center">
        {!! Form::input('submit', 'submit_save', 'Reset Password', [
                        'class'=>'btn btn-success btn-block btn-flat',
                        'style'=>'min-width: 140px;',
                        'required'=>'required']) !!}
    </div>
@endsection
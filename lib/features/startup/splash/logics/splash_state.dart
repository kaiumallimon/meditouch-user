// File: splash_state.dart

part of 'splash_bloc.dart';

abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashLoadedState extends SplashState {}
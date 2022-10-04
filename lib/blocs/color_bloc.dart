import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ColorEvent {}

class SelectedColorEvent extends ColorEvent {}
class UnSelectedColorEvent extends ColorEvent {}

class ColorBloc extends Bloc<ColorEvent, Color> {
  ColorBloc () : super(Colors.white.withOpacity(0.5)) {
    on<SelectedColorEvent>((event, emit) => emit(Colors.red));
    on<UnSelectedColorEvent>((event, emit) => emit(Colors.white.withOpacity(0.5)));
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CounterEvent {}

class Increment extends CounterEvent {
  final int value;
  Increment({required this.value});
}

class Decrement extends CounterEvent {
  final int value;
  Decrement({required this.value});
}

class InitValue extends CounterEvent {
  final int value;
  InitValue({required this.value});
}
class RebuildEvent extends CounterEvent {
  //RebuildEvent();
}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<InitValue>((event, emit) => emit(event.value));
    on<Increment>((event, emit) => emit(state + event.value));
    on<Decrement>((event, emit) => emit(state - event.value));
    on<RebuildEvent>((event, emit) => emit(state));
  }
}

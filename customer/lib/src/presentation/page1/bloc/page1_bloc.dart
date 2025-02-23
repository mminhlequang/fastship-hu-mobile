import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page1_event.dart';
part 'page1_state.dart';

class Page1Bloc extends Bloc<Page1Event, Page1State> {
  Page1Bloc() : super(Page1Initial()) {
    print('Page1Bloc init');
    on<Page1Event>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  Future<void> close() {
    print('Page1Bloc closed');
    return super.close();
  }
}

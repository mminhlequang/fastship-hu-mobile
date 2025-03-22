import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';

part 'navigation_state.dart';

NavigationCubit get navigationCubit => findInstance<NavigationCubit>();

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(currentIndex: 0));

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}

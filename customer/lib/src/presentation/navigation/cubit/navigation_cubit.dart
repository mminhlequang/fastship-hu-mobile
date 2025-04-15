import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:app/src/presentation/widgets/widget_dialog_confirm.dart';
import 'package:app/src/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

part 'navigation_state.dart';

NavigationCubit get navigationCubit => findInstance<NavigationCubit>();

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(currentIndex: 0));

  void changeIndex(int index) async {
    if (index > 2) {
      wrapRequiredLogin(() {
        emit(state.copyWith(currentIndex: index));
      });
    } else {
      emit(state.copyWith(currentIndex: index));
    }
  }
}

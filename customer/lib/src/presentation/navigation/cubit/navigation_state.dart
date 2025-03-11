part of 'navigation_cubit.dart';

class NavigationState   {
  int currentIndex;

   NavigationState({required this.currentIndex});

  NavigationState copyWith({int? currentIndex}) {
    return NavigationState(currentIndex: currentIndex ?? this.currentIndex);
  }
}

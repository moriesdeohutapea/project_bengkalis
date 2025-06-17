import 'package:flutter_bloc/flutter_bloc.dart';

import 'NavigationEvent.dart';
import 'NavigationState.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationTabChanged>((event, emit) {
      final tabName = _getTabName(event.tabIndex);
      emit(NavigationTabSelected(event.tabIndex, tabName));
    });
  }

  String _getTabName(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Favorites';
      case 2:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }
}
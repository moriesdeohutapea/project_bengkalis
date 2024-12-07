import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/NavigationEvent.dart';
import '../state/NavigationState.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationTabChanged>((event, emit) {
      emit(NavigationTabSelected(event.tabIndex));
    });
  }
}

import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationTabSelected extends NavigationState {
  final int tabIndex;

  const NavigationTabSelected(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

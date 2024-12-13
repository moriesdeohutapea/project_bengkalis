import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationTabSelected extends NavigationState {
  final int tabIndex;
  final String tabName;

  const NavigationTabSelected(this.tabIndex, this.tabName);

  @override
  List<Object> get props => [tabIndex, tabName];
}
// vive_huanchaco/lib/features/places/presentation/bloc/navigation_event.dart
part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToTabEvent extends NavigationEvent {
  final int tabIndex;

  const NavigateToTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class NavigateToDrawerItemEvent extends NavigationEvent {
  final int drawerItemIndex;

  const NavigateToDrawerItemEvent(this.drawerItemIndex);

  @override
  List<Object> get props => [drawerItemIndex];
}
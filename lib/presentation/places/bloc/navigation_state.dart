// vive_huanchaco/lib/features/places/presentation/bloc/navigation_state.dart
part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  final int currentIndex;
  const NavigationState(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial(super.currentIndex);
}

class NavigationTabChanged extends NavigationState {
  const NavigationTabChanged(super.currentIndex);
}

class NavigationDrawerItemChanged extends NavigationState {
  final int drawerItemIndex; // Podrías usar esto para un estado más específico del Drawer.
  const NavigationDrawerItemChanged(this.drawerItemIndex) : super(0); // Reinicia tab al cambiar drawer

  @override
  List<Object> get props => [drawerItemIndex, currentIndex];
}
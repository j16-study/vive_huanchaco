// vive_huanchaco/lib/features/places/presentation/bloc/navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';
part 'navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationInitial(0)) {
    on<NavigateToTabEvent>((event, emit) {
      emit(NavigationTabChanged(event.tabIndex));
    });
    on<NavigateToDrawerItemEvent>((event, emit) {
      emit(NavigationDrawerItemChanged(event.drawerItemIndex));
    });
  }
}
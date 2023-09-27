import 'package:flutter_bloc/flutter_bloc.dart';
part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateToPage>((event, emit) {
      emit(state.copyWith(route: event.route, routeType: event.routeType));
    });
    on<ShowSnackBar>((event, emit) async {
      emit(state.copyWith(
          message: event.message, messageType: event.messageType));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(message: null, messageType: null));
    });
  }
}

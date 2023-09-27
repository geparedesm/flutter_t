part of 'navigation_bloc.dart';

abstract class NavigationEvent {}

class NavigateToPage extends NavigationEvent {
  final String route;
  final String routeType;
  NavigateToPage(this.route, this.routeType);
}

class ShowSnackBar extends NavigationEvent {
  final String message;
  final String messageType;
  ShowSnackBar(this.message, this.messageType);
}

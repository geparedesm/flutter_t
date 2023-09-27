part of 'navigation_bloc.dart';

class NavigationState {
  final String route;
  final String? routeType;
  final String? message;
  final String? messageType;
  const NavigationState(
      {this.route = "", this.routeType, this.message, this.messageType});
  NavigationState copyWith(
          {String? route,
          String? routeType,
          String? message,
          String? messageType}) =>
      NavigationState(
        route: route ?? this.route,
        routeType: routeType ?? this.routeType,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
      );
}

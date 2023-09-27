part of 'helpers.dart';

Future<void> showSnackBar(BuildContext context, String message) async {
  Future.delayed(Duration.zero, () {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  });
}

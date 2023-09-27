import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget? leading;
  final double? leadingWidth;
  const CustomAppBarWidget({Key? key, this.leading, this.leadingWidth})
      : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading: leading,
      leadingWidth: leadingWidth,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Gabriel Paredes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            ' - Technical Test',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

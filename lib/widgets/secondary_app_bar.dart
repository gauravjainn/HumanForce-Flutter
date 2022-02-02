import 'package:flutter/material.dart';
import 'package:human_forces/routes/router.gr.dart' as myRouter;
import 'package:human_forces/widgets/cart_fab_button.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final bool isLeading;

  const SecondaryAppBar(
      {@required this.title, @required this.height, this.isLeading = false});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: Row(
        children: [
          IconButton(
            onPressed: () {
              myRouter.Router.navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      leadingWidth: 48,
      actions: [
        if (isLeading) ...{
          CartFabButton(
            fabColor: Colors.black,
            fabSize: 28,
            isCountRight: true,
          )
        }
      ],
      title: Text(
        "$title",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

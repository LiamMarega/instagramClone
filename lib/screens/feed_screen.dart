import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: mobileBackgroundColor,
      centerTitle: false,
      title: SvgPicture.asset(
        'assets/images/ic_instagram.svg',
        color: primaryColor,
        height: 30,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.message_outlined),
        )
      ],
    ));
  }
}

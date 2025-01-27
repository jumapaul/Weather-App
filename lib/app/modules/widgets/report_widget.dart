import 'package:flutter/material.dart';

import '../../common/dimens/dimens.dart';

class ReportWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;

  const ReportWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFFADD8E6),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        AppTextStyle.smallVerticalSpacing,
        Column(
          children: [Text(title), Text('$amount')],
        )
      ],
    );
    ;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WindWidget extends StatelessWidget {
  final double windValue;
  const WindWidget({super.key, required this.windValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 0.45,
      height: MediaQuery.of(Get.context!).size.width * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFFADD8E6).withOpacity(0.2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wind'),
          Text('${windValue.toInt()} ms'),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/wind_direction.png'),
          )
        ],
      ),
    );;
  }
}

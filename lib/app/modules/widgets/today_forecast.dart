import 'package:flutter/material.dart';
import 'package:weather/app/data/models/three_hour_forecast.dart';

import '../../common/dimens/dimens.dart';

class TodayForecast extends StatelessWidget {
  final List<dynamic> list;
  const TodayForecast({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), //Color(0xFFADD8E6)
          color: Color(0xFFADD8E6).withOpacity(0.2)),
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.timelapse),
                AppTextStyle.mediumHorizontalSpacing,
                Text(
                  '24-HR FORECAST',
                  style: AppTextStyle.largeSubHeaderStyle,
                )
              ],
            ),
            AppTextStyle.mediumVerticalSpacing,
            Expanded(
              child: ListView.separated(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var item = list[index];
                  String? timeOnly = item.dtTxt
                      ?.split(' ')[1]
                      .substring(0, 5)
                      .replaceAll(':', '.');
                  return Column(
                    children: [
                      Text(timeOnly ?? ""),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.cloud,
                        size: 40,
                        color: Color(0xFFADD8E6),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${item.main?.temp?.toInt()}\u00B0F')
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 30,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

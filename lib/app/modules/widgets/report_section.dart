import 'package:flutter/material.dart';
import 'package:weather/app/modules/widgets/report_widget.dart';

import '../../common/dimens/dimens.dart';

class ReportSection extends StatelessWidget {
  final String feelsLike;
  final String precipitation;
  final String uvIndex;
  final String wind;
  final String humidity;
  final String cloudiness;

  const ReportSection(
      {super.key,
      required this.feelsLike,
      required this.precipitation,
      required this.uvIndex,
      required this.wind,
      required this.humidity,
      required this.cloudiness});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ReportWidget(
                      icon: Icons.thermostat,
                      title: 'Feels like',
                      amount: feelsLike),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  ReportWidget(
                      icon: Icons.water_drop_outlined,
                      title: 'Precipitation',
                      amount: '$precipitation%'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  ReportWidget(
                      icon: Icons.sunny, title: 'UV Index', amount: uvIndex)
                ],
              ),
            ),
          ),
          AppTextStyle.mediumVerticalSpacing,
          Divider(
            height: 1,
            color: Color(0xFFADD8E6).withOpacity(0.7),
          ),
          AppTextStyle.mediumVerticalSpacing,
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReportWidget(
                      icon: Icons.wind_power,
                      title: 'Wind',
                      amount: '$wind m/s'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  ReportWidget(
                      icon: Icons.water_drop,
                      title: "Humidity",
                      amount: '$humidity%'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  ReportWidget(
                      icon: Icons.cloud,
                      title: "Cloudiness",
                      amount: '$cloudiness%')
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFADD8E6).withOpacity(0.2)),
    );
    ;
  }
}

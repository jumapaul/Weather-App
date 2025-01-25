import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weather/app/common/dimens/dimens.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SafeArea(
          child: Obx(
            () {
              var status = controller.status;
              var data = controller.weatherData.value;
              if (status.value.isSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextStyle.mediumVerticalSpacing,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data?.name}, ${data?.sys?.country}',
                              style: AppTextStyle.largeSubHeaderStyle,
                            ),
                            Text("${controller.currentDay.value}")
                          ],
                        ),
                        Spacer(),
                        _buildSwitchButtonWidget()
                      ],
                    ),
                    AppTextStyle.extraLargeVerticalSpacing,
                    Text(
                      "${data?.main?.temp}",
                      style: AppTextStyle.headerStyle,
                    ),
                    Text(
                      "${data?.weather?[0].description}",
                      style: AppTextStyle.largeSubHeaderStyle,
                    ),
                    AppTextStyle.extraLargeVerticalSpacing,
                    _buildReportSection(
                        data?.main?.feelsLike,
                        100,
                        'Low',
                        data?.wind?.speed,
                        data?.main?.humidity,
                        data?.clouds?.all)
                  ],
                );
              } else if (status.value.isError) {
                return Center(
                  child: Text('An error occurred'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _buildReportSection(
      feelsLike, precipitation, uvIndex, wind, humidity, cloudiness) {
    return Container(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  _buildReportWidget(Icons.thermostat, 'Feels like', feelsLike),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  _buildReportWidget(Icons.water_drop_outlined, 'Precipitation',
                      '${precipitation}%'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  _buildReportWidget(Icons.sunny, 'UV Index', uvIndex)
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
                  _buildReportWidget(Icons.wind_power, 'Wind', '$wind m/s'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  _buildReportWidget(
                      Icons.water_drop, "Humidity", '$humidity%'),
                  VerticalDivider(
                    color: Color(0xFFADD8E6).withOpacity(0.7),
                    thickness: 1,
                  ),
                  _buildReportWidget(Icons.cloud, "Cloudiness", '$cloudiness%')
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
  }

  _buildReportWidget(icon, title, amount) {
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
  }

  _buildSwitchButtonWidget() {
    return ToggleSwitch(
      minWidth: 60,
      cornerRadius: 10,
      activeBgColor: [Color(0xFFADD8E6)],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey.withOpacity(0.3),
      inactiveFgColor: Colors.black,
      initialLabelIndex: 1,
      totalSwitches: 2,
      labels: ['\u00B0C', '\u00B0F'],
      radiusStyle: true,
      onToggle: (index) {
        //todo
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:weather/app/common/dimens/dimens.dart';
import 'package:weather/app/modules/widgets/gauge_widget.dart';
import 'package:weather/app/modules/widgets/report_section.dart';
import 'package:weather/app/modules/widgets/today_forecast.dart';
import 'package:weather/app/modules/widgets/wind_widget.dart';
import 'package:weather/app/routes/app_pages.dart';

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
                return SingleChildScrollView(
                  child: Column(
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
                          IconButton(
                              onPressed: () {
                                Get.toNamed(Routes.SEARCH_PAGE);
                              },
                              icon: Icon(Icons.search))
                        ],
                      ),
                      AppTextStyle.extraLargeVerticalSpacing,
                      Text(
                        "${data?.main?.temp?.toInt()}\u00B0F",
                        style: AppTextStyle.headerStyle,
                      ),
                      Text(
                        "${data?.weather?[0].description}",
                        style: AppTextStyle.largeSubHeaderStyle,
                      ),
                      AppTextStyle.extraLargeVerticalSpacing,
                      ReportSection(
                          feelsLike: '${data?.main?.feelsLike?.toInt()}\u00B0F',
                          precipitation: '100',
                          uvIndex: 'Low',
                          wind: '${data?.wind?.speed}',
                          humidity: '${data?.main?.humidity}',
                          cloudiness: '${data?.clouds?.all}'),
                      AppTextStyle.mediumVerticalSpacing,
                      TodayForecast(list: controller.todayData),
                      AppTextStyle.mediumVerticalSpacing,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WindWidget(
                              windValue: controller.windSpeed.value ?? 0.0),
                          GaugeWidget(
                            progress: controller.humidity.value ?? 0.0,
                            title: 'Humidity',
                            maxValue: 100,
                            unit: 'g/Kg',
                          )
                        ],
                      ),
                      AppTextStyle.mediumVerticalSpacing,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GaugeWidget(
                            progress: controller.pressure.value ?? 0.0,
                            title: 'Pressure',
                            maxValue: 3000,
                            unit: 'pa',
                          ),
                          GaugeWidget(
                            progress: controller.tempInFaradays.value ?? 0,
                            title: 'Temp',
                            maxValue: 1000,
                            unit: '\u00B0F',
                          )
                        ],
                      )
                    ],
                  ),
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
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:weather/app/common/dimens/dimens.dart';
import 'package:weather/app/modules/widgets/report_section.dart';
import 'package:weather/app/modules/widgets/today_forecast.dart';

import '../../widgets/gauge_widget.dart';
import '../../widgets/wind_widget.dart';
import '../controllers/search_page_controller.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                onFieldSubmitted: (value) {
                  controller.getLocationData().then((_) async {
                    await controller.getFiveDayData();
                  });
                },
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Enter City',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Get.theme.colorScheme.inverseSurface),
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: Get.theme.colorScheme.inverseSurface),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              AppTextStyle.mediumVerticalSpacing,
              Obx(() {
                var data = controller.weatherData.value;

                if (controller.status.value.isSuccess) {
                  return Container(
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ReportSection(
                                feelsLike:
                                    '${data?.main?.feelsLike?.toInt()}\u00B0F',
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
                                    windValue:
                                        controller.windSpeed.value ?? 0.0),
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
                                  progress:
                                      controller.tempInFaradays.value ?? 0,
                                  title: 'Temp',
                                  maxValue: 1000,
                                  unit: '\u00B0F',
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (controller.status.value.isError) {
                  return Center(
                    child: Text('An error occurred'),
                  );
                } else if (controller.status.value.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text('No data'),
                  );
                }
              })
            ],
          )),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '';
import '../../../constants/constants.dart';
import '../../../data/models/area_weather.dart';
import '../../../data/models/three_hour_forecast.dart';

class SearchPageController extends GetxController {
  final Rx<RxStatus> status = RxStatus.loading().obs;
  var weatherData = Rxn<AreaWeather>();
  RxList todayData = [].obs;
  var weeklyData = Rxn<ThreeHourForecast>();
  final Rxn<double> tempInFaradays = Rxn<double>();
  final Rxn<double> windSpeed = Rxn<double>();
  final Rxn<double> pressure = Rxn<double>();
  final Rxn<double> humidity = Rxn<double>();
  final TextEditingController searchController = TextEditingController();

  getLocationData() async {
    try {
      var place = await getLatLongFromPlaceId(searchController.text);
      status.value = RxStatus.loading();
      var response = await GetConnect().get(
          "https://api.openweathermap.org/data/2.5/weather?lat=${place?["latitude"]}&lon=${place?["longitude"]}&appid=${Constants.apiKey}");

      if (response.status.isOk) {
        status.value = RxStatus.success();
        weatherData.value = AreaWeather.fromJson(response.body);
      } else {
        status.value = RxStatus.error();
      }
    } catch (error) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Error occurred')));
    }
  }

  Future<Map<String, double>?> getLatLongFromPlaceId(String placeId) async {
    try {
      final response = await GetConnect().get(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$placeId&key=${Constants.googleApiKey}');
      if (response.statusCode == 200) {
        final data = response.body;

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {
            'latitude': location['lat'],
            'longitude': location['lng'],
          };
        } else {
          print('Error: ${data['status']}');
        }
      } else {
        print('Failed to fetch data: ${response.body['message']}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
    return null;
  }

  getFiveDayData() async {
    try {
      print('================> method is called');
      var place = await getLatLongFromPlaceId(searchController.text);
      var response = await GetConnect().get(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${place?["latitude"]}&lon=${place?["longitude"]}&appid=${Constants.apiKey}');

      if (response.status.isOk) {
        weeklyData.value = ThreeHourForecast.fromJson(response.body);

        if (weatherData.value != null) {
          for (WeatherList item in weeklyData.value!.list!) {
            var formattedDate = item.dtTxt?.split(' ')[0];
            var dateNow = DateTime.now();
            var currentDate =
                '${dateNow.year}-${dateNow.month.toString().padLeft(2, '0')}-${dateNow.day.toString().padLeft(2, '0')}';

            if (formattedDate == currentDate) {
              todayData.add(item);
            }
          }
        }
        // calculateAverages();
        status.value = RxStatus.success();
      } else {
        status.value = RxStatus.error();
      }
    } catch (error) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Error occurred')));
    }
  }

  calculateAverages() {
    if (weeklyData.value?.list == null || weeklyData.value!.list!.isEmpty)
      return;
    var list = weeklyData.value?.list!;

    var sums = list
        ?.fold({'temp': 0.0, 'wind': 0.0, 'pressure': 0.0, 'humidity': 0.0},
            (Map<String, double> sum, WeatherList item) {
          sum['temp'] = (sum['temp'] ?? 0) + (item.main?.temp ?? 0);
          sum['wind'] = (sum['wind'] ?? 0) + (item.wind?.speed ?? 0);
          sum['pressure'] = (sum['pressure'] ?? 0) + (item.main?.pressure ?? 0);
          sum['humidity'] = (sum['humidity'] ?? 0) + (item.main?.humidity ?? 0);

          return sum;
        });

    int length = list!.length;
    tempInFaradays.value = (sums!['temp']! / length).toPrecision(2);
    windSpeed.value = (sums['wind']! / length).toPrecision(2);
    pressure.value = (sums['pressure']! / length).toPrecision(2);
    humidity.value = (sums['humidity']! / length).toPrecision(2);
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

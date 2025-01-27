import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/app/constants/constants.dart';
import 'package:weather/app/data/models/area_weather.dart';
import 'package:weather/app/data/models/three_hour_forecast.dart';

class HomeController extends GetxController {
  late var longitude;
  late var latitude;

  final Rx<RxStatus> status = RxStatus.loading().obs;
  final Rx<RxStatus> weeklyStatus = RxStatus.loading().obs;
  final Rxn<double> tempInFaradays = Rxn<double>();
  final Rxn<double> windSpeed = Rxn<double>();
  final Rxn<double> pressure = Rxn<double>();
  final Rxn<double> humidity = Rxn<double>();
  var weatherData = Rxn<AreaWeather>();
  var weeklyData = Rxn<ThreeHourForecast>();
  RxList todayData = [].obs;
  var currentDay = "".obs;

  @override
  void onInit() {
    getCurrentLocation().then((_) {
      getCurrentLocationData();
      getFiveDayData();
      getTimeDate();
    });
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

  Future<void> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
    }).catchError((e) {});
  }

  Future<bool> _handleLocationPermission() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));

      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('Location permissions are denied')));

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  getCurrentLocationData() async {
    try {
      status.value = RxStatus.loading();
      var response = await GetConnect().get(
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${Constants.apiKey}");

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

  getFiveDayData() async {
    try {
      weeklyStatus.value = RxStatus.loading();
      var response = await GetConnect().get(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=${Constants.apiKey}');

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
        calculateAverages();
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

  getTimeDate() {
    var currentDate = DateTime.now();
    var formattedDate =
        DateFormat('EEE MMM dd, yyyy h.mm a').format(currentDate);

    currentDay.value = formattedDate;
  }
}

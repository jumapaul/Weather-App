import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/app/data/models/area_weather.dart';

class HomeController extends GetxController {
  late var longitude;
  late var latitude;

  final Rx<RxStatus> status = RxStatus.loading().obs;
  var weatherData = Rxn<AreaWeather>();
  var currentDay = "".obs;

  @override
  void onInit() {
    getCurrentLocation().then((_) {
      getCurrentLocationData();
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
    status.value = RxStatus.loading();
    var response = await GetConnect().get(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=a1a18cb97d73b1016015c42766fe0e46");

    if (response.status.isOk) {
      status.value = RxStatus.success();
      print('--------->response ${response.body}');
      weatherData.value = AreaWeather.fromJson(response.body);
    } else {
      status.value = RxStatus.error();
    }
  }

  getTimeDate() {
    var currentDate = DateTime.now();
    var formattedDate =
        DateFormat('EEE MMM dd, yyyy h.mm a').format(currentDate);

    currentDay.value = formattedDate;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/home_page/view_model/home_view_model.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/loading_container.dart';

part 'widgets/day_average_temperature_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    _offset = Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero)
        .animate(_controller);
  }

  // Get week day
  String convertDateTimeToWeekDate(int weekDate) {
    switch (weekDate) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  // Get avarage from list with date time
  int getAvarageTemperature({List<ListElement>? elenmentList, DateTime? date}) {
    final temperatureInADayList = elenmentList!
        .where((element) => element.dtTxt?.day == date?.day)
        .toList()
        .map((o) => o.main?.temp)
        .toList();
    int sumOfTemperature = temperatureInADayList.fold(0,
        (previousValue, element) => previousValue.toInt() + element!.toInt());
    return sumOfTemperature ~/ (temperatureInADayList.length);
  }

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = context.watch<WeatherViewModel>();
    final now = DateTime.now();
    final nextDay = now.add(const Duration(days: 1));
    final nextTwoDay = now.add(const Duration(days: 2));
    final nextThreeDay = now.add(const Duration(days: 3));
    final nextFourDay = now.add(const Duration(days: 4));
    // On Loading state
    if (weatherViewModel.loading == true) {
      return const LoadingContainer();
    }

    // On Error State
    if (weatherViewModel.onError == true) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(232, 89, 89, 1.0),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: spacing * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                  child: Text('Something went wrong at our end!',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1.0),
                          fontFamily: 'RobotoThin',
                          fontSize: spacing * 6.75))),
              const SizedBox(height: spacing * 5.5),
              MaterialButton(
                onPressed: () {
                  weatherViewModel.getWeather();
                },
                color: const Color.fromRGBO(74, 74, 74, 1.0),
                child: const Text('RETRY',
                    style:
                        TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0))),
              )
            ],
          ),
        ),
      );
    }

    // On Loaded Data State
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 246, 247, 1.0),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: spacing * 7,
            ),
            SizedBox(
              height: spacing * 14,
              child: Text(
                '${weatherViewModel.weather.list?[0].main?.temp?.toInt()}\u00B0',
                style: boldStyle,
              ),
            ),
            SizedBox(
              height: spacing * 6.5,
              child: Text('${weatherViewModel.weather.city?.name}',
                  style: thinStyle),
            ),
            const SizedBox(height: spacing * 7.75),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _offset,
                  child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: spacing * 2)
                              .copyWith(top: spacing * 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300]!,
                                blurRadius: spacing * 0.75)
                          ]),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DayAverageTemperatureContainer(
                                weekDate:
                                    convertDateTimeToWeekDate(nextDay.weekday),
                                temp: getAvarageTemperature(
                                    elenmentList: weatherViewModel.weather.list,
                                    date: nextDay)),
                            DayAverageTemperatureContainer(
                                weekDate: convertDateTimeToWeekDate(
                                    nextTwoDay.weekday),
                                temp: getAvarageTemperature(
                                    elenmentList: weatherViewModel.weather.list,
                                    date: nextTwoDay)),
                            DayAverageTemperatureContainer(
                                weekDate: convertDateTimeToWeekDate(
                                    nextThreeDay.weekday),
                                temp: getAvarageTemperature(
                                    elenmentList: weatherViewModel.weather.list,
                                    date: nextThreeDay)),
                            DayAverageTemperatureContainer(
                                weekDate: convertDateTimeToWeekDate(
                                    nextFourDay.weekday),
                                temp: getAvarageTemperature(
                                    elenmentList: weatherViewModel.weather.list,
                                    date: nextFourDay)),
                            const SizedBox(height: spacing * 12)
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

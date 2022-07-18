part of '../home_page.dart';

class DayAverageTemperatureContainer extends StatelessWidget {
  final String? weekDate;
  final int? temp;
  const DayAverageTemperatureContainer({Key? key, this.temp, this.weekDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: spacing * 10,
          child: Row(
            children: [
              Expanded(
                child: Text(weekDate ?? '', style: regularStyle),
              ),
              Text('${temp ?? 'N/A'} C', style: regularStyle),
            ],
          ),
        ),
        Container(
          height: 1.0,
          color: Colors.grey[200],
        ),
      ],
    );
  }
}

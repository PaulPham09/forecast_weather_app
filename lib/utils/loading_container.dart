import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:weather_app/utils/constants.dart';

class LoadingContainer extends StatefulWidget {
  const LoadingContainer({Key? key}) : super(key: key);

  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1250))
    ..repeat();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: AnimatedBuilder(
              animation: _loadingController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _loadingController.value * 2 * math.pi,
                  child: SizedBox(
                    height: spacing * 12,
                    width: spacing * 12,
                    child: Image.asset('assets/images/ic_loading.png'),
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }
}

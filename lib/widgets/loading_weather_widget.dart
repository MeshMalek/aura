import 'package:flutter/material.dart';

class LoadingWeatherWidget extends StatelessWidget {
  const LoadingWeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading weather...'),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class EventLoadingWidget extends StatelessWidget {
  const EventLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

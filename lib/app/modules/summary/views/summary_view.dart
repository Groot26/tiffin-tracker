import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/summary_controller.dart';

class SummaryView extends GetView<SummaryController> {
  const SummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SummaryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SummaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tiffin/app/modules/home/views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await HomeWidget.setAppGroupId(groupId);
  //
  // // Listen for widget launch
  // HomeWidget.widgetClicked.listen((Uri? uri) {
  //   if (uri != null) {
  //     debugPrint('Widget clicked! URI: $uri');
  //   }
  // });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:
          (_, __) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tiffins',
            themeMode: ThemeMode.light,
            home: const HomeView(),
          ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/routes/routes.dart';
import 'features/homepage/homepage_view.dart';
import 'core/constant/text_constant.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: TextConstant.appName,
      theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomepageView(),
    onGenerateRoute: Routes.createRoutes,

    );
  }
}


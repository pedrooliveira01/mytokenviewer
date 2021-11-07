import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytokenview/page/list_token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Tokens';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.blueGrey.shade900,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: ContractsPage(),
      );
}

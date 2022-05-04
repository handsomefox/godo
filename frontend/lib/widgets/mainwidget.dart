import 'package:flutter/material.dart';
import 'package:frontend/auth.dart';
import 'package:frontend/providers/task_model.dart';
import 'package:frontend/storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUser(),
      builder: (context, user) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => createTaskModel(context, user.data),
          ),
        ],
        child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            title: AppLocalizations.of(context)?.appName == null
                ? "godo"
                : AppLocalizations.of(context)!.appName,
            home: HomePage(user: user.data)),
      ),
    );
  }

  Future<User?> getUser() async {
    var data = await MyStorage.read();

    if (data == null) {
      return null;
    }

    // return User(
    //     email: data.email,
    //     name: data.name,
    //     token: data.access,
    //     refresh: data.refresh);

    var authApi = AuthApi();
    var response = await authApi
        .login(data.email, data.password)
        .timeout(const Duration(seconds: 2));

    if (response == null) {
      return null;
    }

    if (response.statusCode != 200) {
      return null;
    }

    User user = User.fromReqBody(response.body);
    MyStorage.save(Data(
      email: user.email,
      name: user.name,
      password: data.password,
      access: user.token,
      refresh: user.refresh,
    ));

    return user;
  }

  TaskModel createTaskModel(BuildContext context, User? user) {
    if (user != null) {
      return TaskModel.fromUser(context, user);
    }
    return TaskModel();
  }

  ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      colorScheme: lightColorScheme,
    );
  }

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      colorScheme: darkColorScheme,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    // Primary
    primary: Color.fromARGB(255, 133, 89, 218),
    onPrimary: Colors.white,
    // Accent
    secondary: Color.fromARGB(255, 250, 87, 136),
    onSecondary: Colors.white,
    // Background

    background: Colors.white,
    onBackground: Colors.black,
    // Brightness
    brightness: Brightness.light,
    // Error
    error: Colors.white,
    onError: Colors.black,
    // Surface
    surface: Colors.white,
    onSurface: Colors.black,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    // Primary
    primary: Color.fromARGB(255, 20, 0, 120),
    onPrimary: Colors.white,
    // Accent
    secondary: Color.fromARGB(255, 140, 0, 50),
    onSecondary: Colors.white,
    // Background
    background: Colors.black,
    onBackground: Colors.white,
    // Brightness
    brightness: Brightness.dark,
    // Error
    error: Colors.white,
    onError: Colors.black,
    // Surface
    surface: Color.fromARGB(255, 18, 18, 18),
    onSurface: Colors.white,
  );
}

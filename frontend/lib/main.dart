import 'package:flutter/material.dart';
import 'package:frontend/auth.dart';
import 'package:frontend/storage.dart';
import 'package:frontend/widgets/mainwidget.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: getUser(),
      builder: (context, user) {
        FlutterNativeSplash.remove();
        return MainWidget(user: user.data);
      },
    );
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const TodoApp());
}

Future<User?> getUser() async {
  var data = await MyStorage.read();

  if (data == null) {
    return null;
  }

  var authApi = AuthApi();
  var response = await authApi
      .login(data.email, data.password)
      .timeout(const Duration(seconds: 5));

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

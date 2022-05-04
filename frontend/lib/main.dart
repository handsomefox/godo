import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:frontend/widgets/app_widget.dart';
import 'package:http/http.dart' as http;

Future<User?> loadUser() async {
  Data? storage = await StorageService.read();
  if (storage == null) {
    return null;
  }

  AuthApiService authApi = AuthApiService();
  http.Response? response = await authApi
      .login(storage.email, storage.password)
      .timeout(const Duration(seconds: 5));

  if (response == null || response.statusCode != 200) {
    return null;
  }

  User user = User.fromRequestBody(response.body);
  StorageService.save(Data(
    email: user.email,
    name: user.name,
    password: storage.password,
    accessToken: user.accessToken,
    refreshToken: user.refreshToken,
  ));

  return user;
}

class GodoApplication extends StatelessWidget {
  const GodoApplication({Key? key, this.user}) : super(key: key);

  final User? user;
  @override
  Widget build(BuildContext context) {
    return AppWidget(user: user);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? user = await loadUser();
  runApp(GodoApplication(
    user: user,
  ));
}

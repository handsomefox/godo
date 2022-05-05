import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static void save(Data data) {
    if (kIsWeb) {
      return;
    }
    storage.write(key: 'access', value: data.accessToken);
    storage.write(key: 'refresh', value: data.refreshToken);
    storage.write(key: 'name', value: data.name);
    storage.write(key: 'email', value: data.email);
    storage.write(key: 'password', value: data.password);
  }

  static Future<Data?> read() async {
    if (kIsWeb) {
      return null;
    }
    String? email = await storage.read(key: 'email');
    String? name = await storage.read(key: 'name');
    String? password = await storage.read(key: 'password');
    String? accessToken = await storage.read(key: 'access');
    String? refreshToken = await storage.read(key: 'refresh');

    if (email == null ||
        name == null ||
        password == null ||
        accessToken == null ||
        refreshToken == null) {
      return null;
    }
    return Data(
      email: email,
      name: name,
      password: password,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  static void clear() {
    if (kIsWeb) {
      return;
    }
    storage.delete(key: 'access');
    storage.delete(key: 'refresh');
    storage.delete(key: 'name');
    storage.delete(key: 'email');
    storage.delete(key: 'password');
  }
}

class Data {
  Data({
    required this.email,
    required this.name,
    required this.password,
    required this.accessToken,
    required this.refreshToken,
  });

  final String email;
  final String name;
  final String password;
  final String accessToken;
  final String refreshToken;
}

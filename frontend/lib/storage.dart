import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyStorage {
  static const storage = FlutterSecureStorage();

  static void save(Data data) {
    storage.write(key: "access", value: data.access);
    storage.write(key: "refresh", value: data.refresh);
    storage.write(key: "name", value: data.name);
    storage.write(key: "email", value: data.email);
    storage.write(key: "password", value: data.password);
  }

  static Future<Data?> read() async {
    var email = await storage.read(key: "email");
    var name = await storage.read(key: "name");
    var password = await storage.read(key: "password");
    var access = await storage.read(key: "access");
    var refresh = await storage.read(key: "refresh");

    if (email == null ||
        name == null ||
        password == null ||
        access == null ||
        refresh == null) {
      return null;
    }
    return Data(
      email: email,
      name: name,
      password: password,
      access: access,
      refresh: refresh,
    );
  }

  static void clear() {
    storage.delete(key: "access");
    storage.delete(key: "refresh");
    storage.delete(key: "name");
    storage.delete(key: "email");
    storage.delete(key: "password");
  }
}

class Data {
  final String email;
  final String name;
  final String password;
  final String access;
  final String refresh;
  Data(
      {required this.email,
      required this.name,
      required this.password,
      required this.access,
      required this.refresh});
}

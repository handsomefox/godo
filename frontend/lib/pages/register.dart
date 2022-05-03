import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:frontend/widgets/name_input.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/widgets/gologo.dart';
import 'package:frontend/widgets/password_input.dart';
import 'package:frontend/widgets/email_input.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.registerText)),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              const GoLogo(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              NameInput(nameController: nameController),
              EmailInput(emailController: emailController),
              PasswordInput(passwordController: passwordController),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              RegisterButton(
                emailController: emailController,
                nameController: nameController,
                passwordController: passwordController,
              ),
            ],
          )),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(AppLocalizations.of(context)!.registerText),
          onPressed: () async {
            var regdata = RegisterData(nameController.text,
                emailController.text, passwordController.text);

            if (!regdata.email.isValidEmail(true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidEmail)),
              );
              return;
            }

            if (!regdata.name.isValidName()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidName)),
              );
              return;
            }

            if (!regdata.password.isValidPwd()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.invalidPassword)),
              );
              return;
            }
            const storage = FlutterSecureStorage();

            var encoded = regdata.toJson();
            var str = 'http://127.0.0.1:8080/api/v1/auth/register';
            var url = Uri.parse(str);
            var resp = await http.post(url, body: encoded);
            var decoded = jsonDecode(resp.body);

            var error = decoded["error"].toString();
            if (error == "true") {
              var data = AppLocalizations.of(context)!.errorRegister +
                  decoded["message"].toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data)),
              );
              return;
            }
            storage.write(key: "access_token", value: decoded["access_token"]);
            storage.write(
                key: "refresh_token", value: decoded["refresh_token"]);
            Navigator.pop(context);
          },
        ));
  }
}

class RegisterData {
  final String name;
  final String email;
  final String password;

  RegisterData(this.name, this.email, this.password);

  toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

Future<bool> checkInDatabase(String email) async {
  var str = 'http://127.0.0.1:8080/api/v1/auth/check-email/' + email;
  var url = Uri.parse(str);
  var resp = await http.post(url);
  var exists = jsonDecode(resp.body)['exists'];
  return exists as bool;
}

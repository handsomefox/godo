import 'dart:convert';
import 'package:frontend/auth.dart';
import 'package:frontend/storage.dart';
import 'package:frontend/widgets/home.dart';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/mainwidget.dart';
import 'package:frontend/widgets/name_input.dart';

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
            var email = emailController.text;
            var password = passwordController.text;
            var name = nameController.text;

            if (!email.isValidEmail()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidEmail)),
              );
              return;
            }
            if (!password.isValidPwd()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.invalidPassword)),
              );
              return;
            }

            if (!name.isValidName()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidName)),
              );
              return;
            }
            var api = AuthApi();

            var response = await api.register(name, email, password);
            if (response == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.serverError)),
              );
              return;
            }
            var json = jsonDecode(response.body);

            if (response.statusCode != 200) {
              var errorMessage = json["message"].toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
              return;
            }
            User user = User.fromReqBody(response.body);
            MyStorage.save(Data(
              email: user.email,
              name: user.name,
              password: password,
              access: user.token,
              refresh: user.refresh,
            ));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.loginSuccess)),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainWidget(),
                  maintainState: false),
              (route) => false,
            );
          },
        ));
  }
}

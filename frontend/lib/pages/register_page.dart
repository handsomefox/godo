import 'dart:convert';
import 'package:godo/services/api_service.dart';
import 'package:godo/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:godo/widgets/app_widget.dart';
import 'package:godo/widgets/name_input_widget.dart';
import 'package:godo/widgets/gologo_widget.dart';
import 'package:godo/widgets/password_input_widget.dart';
import 'package:godo/widgets/email_input_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.registerText)),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              const GoLogoWidget(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              NameInputWidget(nameController: _nameController),
              EmailInputWidget(emailController: _emailController),
              PasswordInputWidget(passwordController: _passwordController),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              RegisterButton(
                emailController: _emailController,
                nameController: _nameController,
                passwordController: _passwordController,
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
            String emailText = emailController.text;
            String passwordText = passwordController.text;
            String nameText = nameController.text;

            if (!emailText.isValidEmail()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidEmail)),
              );
              return;
            }
            if (!passwordText.isValidPwd()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.invalidPassword)),
              );
              return;
            }
            if (!nameText.isValidName()) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.invalidName)),
              );
              return;
            }

            AuthApiService api = AuthApiService();
            http.Response? response =
                await api.register(nameText, emailText, passwordText);
            if (response == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)!.serverError)),
              );
              return;
            }
            var decodedBody = jsonDecode(response.body);

            if (response.statusCode != 200) {
              String errorMessage = decodedBody['message'].toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
              return;
            }
            User user = User.fromRequestBody(response.body);
            StorageService.save(Data(
              email: user.email,
              name: user.name,
              password: passwordText,
              accessToken: user.accessToken,
              refreshToken: user.refreshToken,
            ));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.loginSuccess)),
            );
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AppWidget(
                        user: user,
                      ),
                  maintainState: false),
              (Route route) => false,
            );
          },
        ));
  }
}

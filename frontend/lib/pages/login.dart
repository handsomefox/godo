import 'package:flutter/material.dart';
import 'package:frontend/widgets/gologo.dart';
import 'package:frontend/widgets/password_input.dart';
import 'package:frontend/widgets/email_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              const GoLogo(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              EmailInput(emailController: emailController),
              PasswordInput(passwordController: passwordController),
              const Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              LoginButton(
                  emailController: emailController,
                  passwordController: passwordController),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            ],
          )),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);
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
          child: Text(
            AppLocalizations.of(context)!.login,
          ),
          onPressed: () async {
            // var loginData =
            // LoginData(emailController.text, passwordController.text);

            // if (!loginData.email.isValidEmail(true)) {
            // ScaffoldMessenger.of(context).showSnackBar(
            // const SnackBar(content: Text('Invalid Email')),
            // );
            // return;
            // }

            // if (!loginData.password.isValidPwd()) {
            // ScaffoldMessenger.of(context).showSnackBar(
            // const SnackBar(content: Text('Invalid Password')),
            // );
            // return;
            // }
            // const storage = FlutterSecureStorage();

            // var encoded = loginData.toJson();

            // var str = 'http://127.0.0.1:8080/api/v1/auth/login';
            // var url = Uri.parse(str);
            // var resp = await http.post(url, body: encoded);
            // var decoded = jsonDecode(resp.body);

            // var error = decoded["error"].toString();
            // if (error == "true") {
            //   var data = 'Error logging in: ' + decoded["message"].toString();
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(data)),
            //   );
            //   return;
            // }
            // storage.write(key: "access_token", value: decoded["access_token"]);
            // storage.write(
            //     key: "refresh_token", value: decoded["refresh_token"]);

            // const loginSuccess = "Logged in successfully";
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text(loginSuccess)),
            // );
            Navigator.pop(context);
          },
        ));
  }
}

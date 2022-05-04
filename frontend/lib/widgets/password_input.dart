import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) {
          return input!.isValidPwd()
              ? null
              : AppLocalizations.of(context)!.passwordTooltip;
        },
        cursorColor: Theme.of(context).colorScheme.onBackground,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            border: const OutlineInputBorder(),
            labelText: AppLocalizations.of(context)!.password,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            )),
      ),
    );
  }
}

extension PasswordValidator on String {
  bool isValidPwd() {
    return RegExp(r'(?=.*?[a-z])(?=.*?[0-9]).{8,}').hasMatch(this);
  }
}

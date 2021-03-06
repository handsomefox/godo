import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? input) {
          return input!.isValidEmail()
              ? null
              : AppLocalizations.of(context)!.emailTooltip;
        },
        cursorColor: Theme.of(context).colorScheme.onBackground,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        controller: emailController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: AppLocalizations.of(context)!.email,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

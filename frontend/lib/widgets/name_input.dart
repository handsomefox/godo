import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) {
          return input!.isValidName()
              ? null
              : AppLocalizations.of(context)!.nameTooltip;
        },
        cursorColor: Theme.of(context).colorScheme.onBackground,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        controller: nameController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: AppLocalizations.of(context)!.name,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}

extension NameValidator on String {
  bool isValidName() {
    return RegExp(r'.{3,}').hasMatch(this);
  }
}

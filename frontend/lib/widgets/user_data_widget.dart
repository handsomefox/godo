import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDataWidget extends StatelessWidget {
  const UserDataWidget({Key? key, this.userIcon, this.name}) : super(key: key);

  final String? name;
  final IconData? userIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          userIcon ?? Icons.person,
          size: 36.0,
        ),
        const Padding(
            padding: EdgeInsets.only(
          left: 8.0,
        )),
        Text(name ?? AppLocalizations.of(context)!.emptyUsername,
            style: getTitleTextStyle(context)),
      ],
    );
  }

  TextStyle getTitleTextStyle(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onBackground;
    return TextStyle(
      color: textColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
  }
}

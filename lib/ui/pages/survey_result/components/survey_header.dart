import 'package:flutter/material.dart';

class SurveyHeader extends StatelessWidget {
  final String header;

  const SurveyHeader({
    Key? key,
    required this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withAlpha(90)
      ),
      child: Text(header),
    );
  }
}
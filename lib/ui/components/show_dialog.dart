import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  final String nameApp;
  final String subtitle;
  final String nameButton;
  final VoidCallback? onPressed;

  const ShowDialog({
    Key? key, 
    required this.nameApp, 
    required this.subtitle, 
    required this.nameButton,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 13,
              backgroundImage: AssetImage('assets/icon/ios.png'),
            ),
          ),
          Text(
            nameApp,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          subtitle,
          overflow: TextOverflow.clip,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
        ),
      ),
      actions: <Widget>[
        //Botão Começar
        TextButton(
          child: Text(
            nameButton,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: onPressed
        )
      ],
    );
  }
}
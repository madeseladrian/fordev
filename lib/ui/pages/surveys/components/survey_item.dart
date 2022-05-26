import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  const SurveyItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 2,
            color: Colors.black
          )
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '20 de agosto de 2020',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Qual é seu framework favorito?',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
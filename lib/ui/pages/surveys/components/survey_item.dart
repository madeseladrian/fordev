import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  const SurveyItem({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('survey_item_${viewModel.id}'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: viewModel.didAnswer 
          ? Theme.of(context).secondaryHeaderColor 
          : Theme.of(context).primaryColorDark,
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
        children: [
          Text(
            viewModel.date,
            style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          Text(
            viewModel.question,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../pages/pages.dart';

class SurveyAnswerResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({required String answer}) onSave;
  
  const SurveyAnswerResult({
    Key? key,
    required this.viewModel,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(header: viewModel.question);
        }
        final answer = viewModel.answers[index - 1];
        return GestureDetector(
          onTap: answer.isCurrentAnswer ? null : () => onSave(answer: answer.answer),
          child: SurveyAnswer(viewModel: answer)
        );
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
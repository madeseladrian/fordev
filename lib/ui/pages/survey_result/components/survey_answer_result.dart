import 'package:flutter/material.dart';

import '../../../pages/pages.dart';

class SurveyAnswerResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  
  const SurveyAnswerResult({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(header: viewModel.question);
        }
        return SurveyAnswer(viewModel: viewModel.answers[index - 1]);
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
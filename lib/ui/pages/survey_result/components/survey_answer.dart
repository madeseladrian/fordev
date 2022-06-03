import 'package:flutter/material.dart';

import '../survey_answer_viewmodel.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  const SurveyAnswer({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              viewModel.image != null
                ? Image.network(viewModel.image!)
                : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    viewModel.answer, 
                    style: const TextStyle(fontSize: 16)
                  ),
                )),
              Text(
                viewModel.percent, 
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )
              ),
              viewModel.isCurrentAnswer
                ? const ActiveIcon() : const DisabledIcon()
            ],
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }
}
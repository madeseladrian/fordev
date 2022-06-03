import 'package:flutter/material.dart';

import 'package:fordev/ui/pages/pages.dart';

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
                  viewModel.answers[index - 1].image != null
                    ? Image.network(viewModel.answers[index - 1].image!)
                    : Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        viewModel.answers[index - 1].answer, 
                        style: const TextStyle(fontSize: 16)
                      ),
                    )),
                  Text(
                    viewModel.answers[index - 1].percent, 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  viewModel.answers[index - 1].isCurrentAnswer
                    ? const ActiveIcon() : const DisabledIcon()
                ],
              ),
            ),
            const Divider(height: 1)
          ],
        );
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
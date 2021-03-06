import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'survey_result.dart';

class SurveyResultPage extends StatelessWidget with SessionManager {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveyResult), centerTitle: true),
      body: Builder(
        builder: (context) {
          presenter.loadData();
          handleSessionExpired(presenter.isSessionExpiredStream);

          return StreamBuilder<SurveyResultViewModel?>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyAnswerResult(
                  viewModel: snapshot.data!,
                  onSave: presenter.save
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          );
        }
      )
    );
  }
}
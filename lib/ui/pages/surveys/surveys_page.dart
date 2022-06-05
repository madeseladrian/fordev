import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import 'surveys.dart';

class SurveysPage extends StatelessWidget with NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  const SurveysPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys), centerTitle: true),
      body: Builder(
        builder: (context) {
          presenter.loadData();
          handleSessionExpired(presenter.isSessionExpiredStream);
          handleNavigation(presenter.navigateToStream);
          
          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return ListenableProvider(
                  create: (_) => presenter,
                  child: SurveyItems(viewModels: snapshot.data)
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
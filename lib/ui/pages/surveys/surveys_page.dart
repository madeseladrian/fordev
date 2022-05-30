import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(title: Text(R.string.surveys)),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.loadSurveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Center(child: Text(snapshot.error.toString())),
                    ElevatedButton(
                      child: Text(R.string.reload),
                      onPressed: null,
                    ),
                  ],
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      aspectRatio: 1
                    ),
                    items: snapshot.data?.map(
                      (viewModel) => SurveyItem(viewModel: viewModel)
                    ).toList(),
                  ),
                );
              }
              return const SizedBox(height: 0);
            }
          );
        }
      )
    );
  }
}


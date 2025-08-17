import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/data/models/baby_milestone_data_list.dart';
import 'jaundice_overview_view.dart';
import 'jaundice_symptoms_view.dart';
import 'jaundice_treatment_view.dart';
import 'jaundice_prevention_view.dart';

class JaundiceView extends StatefulWidget {
  const JaundiceView({Key? key}) : super(key: key);

  @override
  State<JaundiceView> createState() => _JaundiceViewState();
}

class _JaundiceViewState extends State<JaundiceView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: NeoSafeColors.warmWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('Jaundice Information'),
          bottom: const TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Symptoms'),
              Tab(text: 'Treatment'),
              Tab(text: 'Prevention'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            JaundiceOverviewView(data: jaundiceData),
            JaundiceSymptomsView(data: jaundiceData),
            JaundiceTreatmentView(data: jaundiceData),
            JaundicePreventionView(data: jaundiceData),
          ],
        ),
      ),
    );
  }
}

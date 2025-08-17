import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/postpartum_care_controller.dart';
import 'postpartum_overview_view.dart';
import 'postpartum_tips_view.dart';
import 'postpartum_breastfeeding_view.dart';
import 'postpartum_family_planning_view.dart';

class PostpartumCareView extends GetView<PostpartumCareController> {
  const PostpartumCareView({Key? key}) : super(key: key);

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
          title: const Text('Postpartum Care'),
          bottom: const TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: "Dos & Don'ts"),
              Tab(text: 'Breastfeeding'),
              Tab(text: 'Family Planning'),
            ],
          ),
        ),
        body: GetX<PostpartumCareController>(
          init: controller,
          builder: (c) {
            final data = c.content.value;
            return TabBarView(
              children: [
                PostpartumOverviewView(data: data),
                PostpartumTipsView(tips: data.tips),
                PostpartumBreastfeedingView(content: data.breastfeeding),
                PostpartumFamilyPlanningView(content: data.familyPlanning),
              ],
            );
          },
        ),
      ),
    );
  }
}

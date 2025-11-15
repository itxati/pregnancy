import 'package:babysafe/app/modules/get_pregnant_requirements/widgets/go_to_home.dart';
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
          actions: [
            GoToHomeIconButton(
              circleColor: NeoSafeColors.primaryPink,
              iconColor: Colors.white,
              top: 0,
            ),
            SizedBox(
              width: 12,
            )
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text('postpartum_care'.tr),
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'overview'.tr),
              Tab(text: 'dos_and_donts'.tr),
              Tab(text: 'breastfeeding'.tr),
              Tab(text: 'family_planning'.tr),
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

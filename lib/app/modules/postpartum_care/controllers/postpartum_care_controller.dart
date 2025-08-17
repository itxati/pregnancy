import 'package:get/get.dart';
import '../../../data/models/postpartum_data.dart';
import '../../../data/models/postpartum_models.dart';

class PostpartumCareController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<PostpartumContent> content = postpartumContent.obs;

  void setLoading(bool loading) {
    isLoading.value = loading;
  }
}

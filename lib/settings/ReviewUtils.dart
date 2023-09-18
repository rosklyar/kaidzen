import 'package:in_app_review/in_app_review.dart';

class ReviewUtils {
  static Future<void> requestReview() async {
    if (await InAppReview.instance.isAvailable()) {
      return InAppReview.instance.requestReview();
    }
  }
}

import 'package:get/get.dart';
import 'package:izo_captain/models/user_model.dart';

class LoginController extends GetxController {
  late RxList<UserModel> users = RxList([]);
  UserModel? user;
  late RxString userName = ''.obs;
}

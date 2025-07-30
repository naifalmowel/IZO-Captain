import 'dart:convert';
import 'package:get/get.dart';
import 'package:izo_captain/models/user_model.dart';
import 'package:izo_captain/server/dio_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  RxBool isLogin = false.obs;
  RxList<UserModel> allUsers = RxList([]);
  RxList<UserModel> users = RxList([]);

  Future<bool> getUsers() async {
    isLogin(true);
    update();
    users.clear();
    allUsers.clear();
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/users');
      if (response.statusCode == 200) {
        var allUser = jsonDecode(response.data);
        for (var i in allUser['users']) {
          allUsers.add(UserModel(
            id: int.tryParse(i['id']) ?? 0,
            name: i['name'],
            password: i['password'],
            type: i['type'],
            isActive: true,
            discount: 0,
          ));
        }
        users.value =
            allUsers.where((p0) => p0.id > 0 && p0.type == 'Captain').toList();
        isLogin(false);
        update();
        return true;
      } else {
        isLogin(false);
        update();
        return false;
      }

    } catch (e) {
      isLogin(false);
      update();
      return false;
    }

  }

  Future<bool> loginUser({required int userId})async{
    DioClient dio = DioClient();
    try{
      final response = await dio.postDio(path: '/login', data1: {"userId":userId});

      if(response.statusCode == 200){
var data = response.data;

return data['message'];
      }else{return false;}
    }catch(e){
      return false;
    }
  }
  Future<bool> logoutUser()async{
    DioClient dio = DioClient();
    try{
      final userId = Get.find<SharedPreferences>().getInt('userId')??0;
      final response = await dio.postDio(path: '/logout', data1: {"userId":userId});
      if(response.statusCode == 200){
        var data = response.data;
        print(data['message']);
        return true;
      }else{return false;}
    }catch(e){
      return false;
    }
  }
}

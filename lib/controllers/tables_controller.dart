import 'package:get/get.dart';
import 'package:izo_captain/controllers/info_controllers.dart';
import 'package:izo_captain/server/dio_services.dart';

class TableController extends GetxController {

  RxBool loading = false.obs;
  Future<String> incTakeaway() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/incT');
      if (response.statusCode == 200) {
        await Get.find<InfoController>().getAllInformation();
        return 'Success';
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> decTakeaway() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/decT');
      if (response.statusCode == 200) {
        await Get.find<InfoController>().getAllInformation();
        return response.data.toString();
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> incDelivery() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/incD');
      if (response.statusCode == 200) {
        await Get.find<InfoController>().getAllInformation();
        return 'Success';
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> decDelivery() async {
    DioClient dio = DioClient();
    try {
      final response = await dio.getDio(path: '/decD');
      if (response.statusCode == 200) {
        await Get.find<InfoController>().getAllInformation();
        return response.data.toString();
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> entryToTable({
    required Map<String, dynamic> data,
  })
  async {
    DioClient dio = DioClient();
    try {
      final response = await dio.postDio(path: '/enter', data1: data);
      Map<String, dynamic> data1 = response.data;
      if (response.statusCode == 200) {
        return data1['message'];
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future<String> exitFromTable({
    required Map<String, dynamic> data,
  })
  async {
    DioClient dio = DioClient();
    try {
      final response = await dio.postDio(path: '/exit', data1: data);
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'ERROR';
      }
    } catch (e) {
      return 'ERROR';
    }
  }

  Future bookingTable({
    required String hall,
    required String table,
    required String date,
    required String guestName,
    required String guestNo,
    required String guestMobile,
  })
  async {
    DioClient dio = DioClient();
    var data ={
      "hall":hall,
      "table":table,
      "date":date,
      "guestName":guestName,
      "guestNo":guestNo,
      "guestMobile":guestMobile,
    };
    try{
      final response = await dio.postDio(path: '/booking', data1: data);
      if(response.statusCode == 200){
        await Get.find<InfoController>().getAllInformation();
      }
    }catch(e){
      print(e);
    }
  }
  Future deleteBooking({
    required String hall,
    required String table,
  })
  async {
    DioClient dio = DioClient();
    var data ={
      "hall":hall,
      "table":table,
    };
    try{
      final response = await dio.postDio(path: '/delete-booking', data1: data);
      if(response.statusCode == 200){
        await Get.find<InfoController>().getAllInformation();
      }
    }catch(e){
      print(e);
    }
  }

}

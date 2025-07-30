import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:izo_captain/controllers/user_controller.dart';
import 'package:izo_captain/modules/qr_code/qr_scanner.dart';
import '../utils/Theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../controllers/info_controllers.dart';
import '../controllers/internet_check_controller.dart';
import 'login/login.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
bool isE = false;
  @override
  void initState() {
    super.initState();

     _controller = VideoPlayerController.asset('assets/video/video.mp4')
       ..initialize().then((_) async {
         setState(() {
           _controller.play();
         });
         if (Get.find<INetworkInfo>().connectionStatus.value == 1) {
           try{
             isE = await Get.find<InfoController>().checkMobile();
             await Get.find<InfoController>().getAllInformation();
             await Get.find<UserController>().getUsers();
           }catch(e){
             isE = false ;
             Get.find<InfoController>().isLoading(false);
             Get.find<InfoController>().isLoadingCheck(false);
           }
         }
       });
    String urlServer = Get.find<SharedPreferences>().getString('url') ?? '';
    Future.delayed(
        const Duration(seconds: 5),
        () => Get.off(
            () =>
            urlServer == '' ? const QRScanner()
                : const LoginPage()
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f3),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Center(
                child: SpinKitFoldingCube(
                color: primaryColor,
                size: 75,
              )),
      ),
    );
  }
}

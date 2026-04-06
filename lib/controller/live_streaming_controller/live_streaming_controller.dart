import 'package:adradio/backend/utils/custom_snackbar.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../backend/model/dashboard/live_show_model.dart';
import '../../backend/services/dashboard_services/dashboard_service.dart';
import '../../utils/basic_screen_imports.dart';

class LiveStreamingController extends GetxController with DashboardService {
  var setVolumeValue = 1.0.obs;
  RxString radioUrl = ''.obs;

  void setVolume(double value) {
    setVolumeValue.value = value;
    audioPlayer.setVolume(value);
  }

  RxBool isPlaying = false.obs;
  RxBool isPlayLoading = false.obs;
  late AudioPlayer audioPlayer;

  void playRadio() async {
    isPlayLoading.value = true;
    update();
    if(!isPlaying.value) {
      try{
        debugPrint(radioUrl.value);
        await audioPlayer.play(UrlSource(radioUrl.value)).then((value) {
          isPlaying.value = true;
        });
        update();
      }catch (e){
        CustomSnackBar.error("");
      }
    }
    else{
      isPlaying.value = false;
      await audioPlayer.stop();
      update();
    }
    isPlayLoading.value = false;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  void onInit() {
    liveShowProcess();
    super.onInit();
  }

  /// ------------------------------------- >>
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late LiveShowModel _liveShowModel;
  LiveShowModel get liveShowModel => _liveShowModel;

  ///* Get LiveShow in process
  Future<LiveShowModel> liveShowProcess() async {
    _isLoading.value = true;
    update();
    await liveShowProcessApi().then((value) {
      _liveShowModel = value!;

      // radioUrl.value = "https://stream.zeno.fm/bpglhfmynymtv";
      radioUrl.value = _liveShowModel.data.schedule.first.radioLink;
      audioPlayer = AudioPlayer();
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _liveShowModel;
  }
}

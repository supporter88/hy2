import 'package:adradio/extensions/custom_extensions.dart';
import 'package:adradio/utils/basic_screen_imports.dart';

import '../../../../backend/local_storage/local_storage.dart';
import '../../../../backend/model/auth/login_model.dart';
import '../../../../backend/services/auth_service/auth_service.dart';
import '../../../../routes/routes.dart';

class RegistrationController extends GetxController with AuthService{
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailAddressController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool agreed = false.obs;

  get onRegistration => registrationProcess();
  get onLogin => Routes.loginScreen.toNamed;

  /// ------------------------------------- >>
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late LoginModel _registrationModel;
  LoginModel get registrationModel => _registrationModel;

  ///* Register in process
  Future<LoginModel> registrationProcess() async {
    _isLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'email': emailAddressController.text,
      'password': passwordController.text,
      'agree': agreed.value ? "on" : "",
    };
    //
    await registrationProcessApi(body: inputBody).then((value) {
      _registrationModel = value!;

      LocalStorage.saveToken(token: _registrationModel.data.token);

      if(_registrationModel.data.authorization.status){
        Get.toNamed(Routes.emailVerificationScreen, arguments: false);
      }else{
        Routes.navigationScreen.offAllNamed;
      }
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _registrationModel;
  }


}
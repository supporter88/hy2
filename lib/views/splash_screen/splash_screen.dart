import 'package:adradio/backend/utils/custom_loading_api.dart';

import '../../../../utils/basic_screen_imports.dart';
import '../../../../utils/responsive_layout.dart';
import '../../controller/settings/basic_settings_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BasicSettingsController>();
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        body: Obx(() => controller.isLoading
            ? const CustomLoadingAPI()
            : Image.network(
                controller.splash.value,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )),
      ),
    );
  }
}

// Use package imports to avoid "path not found" errors
import '../../core/di/injection_container.dart'; 
import 'presentation/provider/home_provider.dart';

void initHome() {
  // Now 'sl' and 'HomeProvider' will be recognized
  sl.registerFactory(() => HomeProvider());
}
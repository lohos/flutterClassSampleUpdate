import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  // 獲取當前位置的非同步方法
  Future<void> getCurrentLocation() async {
    try {
      // 檢查位置服務是否啟用
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("// 如果位置服務未啟用，您可以引導用戶打開位置服務");
        return;
      }

      // 檢查並請求權限
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // 如果權限被拒絕
          print("權限被拒絕");

          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // 如果權限被永久拒絕
        print("權限被永久拒絕");

        return;
      }

      // 獲取當前位置
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // 更新位置數據
      latitude = position.latitude;
      longitude = position.longitude;
      print("latitude = $latitude");
    } catch (e) {
      print(e);
    }
  }
}

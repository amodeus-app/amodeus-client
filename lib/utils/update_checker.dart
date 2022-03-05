import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String?> getNewerVersion() async {
  final client = Dio(BaseOptions(baseUrl: "https://api.github.com/"));
  final Response<List<dynamic>> response;
  try {
    response = await client.get("/repos/evgfilim1/amodeus-client/releases");
  } on DioError {
    return null;
  }
  final latest = (response.data!.first["tag_name"] as String);
  final current = (await PackageInfo.fromPlatform()).version;
  if (latest != current) {
    return latest;
  }
  return null;
}

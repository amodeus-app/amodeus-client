import 'package:amodeus_api/amodeus_api.dart' show AmodeusApi;

import './storage.dart' as storage;

Future<AmodeusApi> getApi() async {
  var baseUrl = await storage.baseURL.get() ?? AmodeusApi.basePath;
  final api = AmodeusApi(basePathOverride: baseUrl);
  return api;
}

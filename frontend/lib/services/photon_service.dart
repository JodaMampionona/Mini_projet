import 'package:frontend/model/place_model.dart';
import 'package:frontend/utils/dio_util.dart';

class PhotonService {
  static const _bbox = '47.44,-19.01,47.61,-18.81';

  static Future<List<Place>> search(String? query) async {
    if (query == null || query.length < 2) return [];

    final response = await dio.get(
      'https://photon.komoot.io/api/',
      queryParameters: {'q': query, 'lang': 'fr', 'bbox': _bbox},
    );

    final data = response.data;

    final features = data['features'] as List;

    return features.map((f) => Place.fromJson(f)).toList();
  }
}

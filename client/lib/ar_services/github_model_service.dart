import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class GithubModelService {

  static const String baseUrl =
      "https://api.github.com/repos/Mohaideen-Abdul-Kathar-S/ar-models/contents/";

  /// 🔹 Fetch all folders
  static Future<List<String>> fetchFolders() async {

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to load folders");
    }

    final List data = json.decode(response.body);

    return data
        .where((item) => item['type'] == 'dir')
        .map<String>((item) => item['name'])
        .toList();
  }

  /// 🔹 Fetch models inside selected folder
  static Future<List<ProductModel>> fetchModels(String folder) async {

    final response = await http.get(Uri.parse("$baseUrl$folder"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load models");
    }

    final List data = json.decode(response.body);

    return data
        .where((item) => item['name'].toString().endsWith('.glb'))
        .map<ProductModel>((item) {
      return ProductModel(
        name: item['name']
            .replaceAll('.glb', '')
            .replaceAll('-', ' ')
            .toUpperCase(),
        modelUrl: item['download_url'],
      );
    }).toList();
  }
}
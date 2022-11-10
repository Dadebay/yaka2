import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:yaka2/app/constants/constants.dart';
import 'package:yaka2/app/data/models/clothes_model.dart';
import 'package:yaka2/app/data/models/collar_model.dart';

import 'auth_service.dart';

class FavService {
  Future<List<DressesModel>> getProductFavList() async {
    final token = await Auth().getToken();

    final List<DressesModel> favListProducts = [];
    final response = await http.get(
      Uri.parse(
        '$serverURL/api/v1/users/me/favorite-products',
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      print(responseJson);
      for (final Map product in responseJson['data']) {
        favListProducts.add(DressesModel.fromJson(product));
      }
      return favListProducts;
    } else {
      return [];
    }
  }

  Future<List<CollarModel>> getCollarFavList() async {
    final token = await Auth().getToken();

    final List<CollarModel> favListCollar = [];
    final response = await http.get(
      Uri.parse(
        '$serverURL/api/v1/users/me/favorites',
      ),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      for (final Map product in responseJson['data']) {
        favListCollar.add(CollarModel.fromJson(product));
      }
      return favListCollar;
    } else {
      return [];
    }
  }

  Future addProductToFav({required int id}) async {
    final token = await Auth().getToken();
    final headers = {
      'Authorization': 'Bearer $token',
    };
    final request = http.MultipartRequest('POST', Uri.parse('$serverURL/api/v1/users/me/favorites-products'));
    request.fields.addAll({'collar_id': '${id}'});

    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future addCollarToFav({required int id}) async {
    final token = await Auth().getToken();

    final headers = {
      'Authorization': 'Bearer $token',
    };
    final request = http.MultipartRequest('POST', Uri.parse('$serverURL/api/v1/users/me/favorites'));
    request.fields.addAll({'collar_id': '${id}'});

    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
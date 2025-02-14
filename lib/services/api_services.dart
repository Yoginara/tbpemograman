import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio_contact/model/fish_model.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://ass-be-7839a19b4578.herokuapp.com/api';

  Future<Iterable<FishModel>?> getAllFish() async {
    try {
      var response = await dio.get('$_baseUrl/betta');
      if (response.statusCode == 200) {
        final fishList = (response.data['data'] as List)
            .map((fish) => FishModel.fromJson(fish))
            .toList();
        return fishList;
      }
      return null;
    } catch (e) {
      debugPrint('Error saat mengambil data ikan: $e');
      return null;
    }
  }

  Future<FishModel?> getSingleFish(String id) async {
    try {
      var response = await dio.get('$_baseUrl/betta/$id');
      if (response.statusCode == 200) {
        return FishModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error saat mengambil detail ikan: $e');
      return null;
    }
  }

  Future<bool> postFish(FishInput ct) async {
    try {
      final response = await dio.post('$_baseUrl/betta', data: ct.toJson());
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('Error saat menambahkan data: $e');
      return false;
    }
  }

  Future<bool> putFish(String id, FishInput ct) async {
    try {
      final response = await dio.put('$_baseUrl/betta/$id', data: ct.toJson());
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error saat memperbarui data: $e');
      return false;
    }
  }

  Future<bool> deleteFish(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/betta/$id');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error saat menghapus data: $e');
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      var response = await dio.post(
        '$_baseUrl/accounts',
        data: {
          "username": username,
          "password": password,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      debugPrint('Error registering: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      var response = await dio.post(
        '$_baseUrl/accounts/auth',
        data: {
          "username": username,
          "password": password,
        },
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('Error logging in: ${e.response?.data ?? e.message}');
      return false;
    }
  }
}

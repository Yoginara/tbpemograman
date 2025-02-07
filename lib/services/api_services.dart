import 'package:dio/dio.dart';
import 'package:dio_contact/model/fish_model.dart';
import 'package:dio_contact/model/login_model.dart';
import 'package:flutter/material.dart';

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
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<FishModel?> getSingleFish(String id) async {
    try {
      var response = await dio.get('$_baseUrl/betta/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return FishModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<FishResponse?> postFish(FishInput ct) async {
    try {
      final response = await dio.post(
        '$_baseUrl/betta',
        data: ct.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return FishResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<FishResponse?> putFish(String id, FishInput ct) async {
    try {
      final response = await Dio().put(
        '$_baseUrl/betta/$id',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return FishResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteFish(String id) async {
    try {
      final response = await Dio().delete('$_baseUrl/betta/$id');
      if (response.statusCode == 200) {
        return FishResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
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

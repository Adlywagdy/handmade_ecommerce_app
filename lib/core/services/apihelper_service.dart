import 'package:dio/dio.dart';

class ApiHelperService {
  static final Dio _dio = Dio();
  ApiHelperService._();
  static Future<Response> get({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await _dio.get(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response!.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> post({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await _dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.response!.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> put({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await _dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.response!.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Response> delete({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    String? contentType,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Response response = await _dio.delete(
        url,
        data: body,
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.response!.data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

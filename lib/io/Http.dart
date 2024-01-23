import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_eng_program/data/server_resp.dart';
import 'package:my_eng_program/util/logger.dart';

class Http {
  static const String TAG = "Http-API";

  static final Http _instance = Http._internal();
  // 单例模式使用Http类，
  factory Http() => _instance;
  static late final Dio _dio;

  Http._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );

    _dio = Dio(options);

    //Request interceptor
    // dio.interceptors.add(RequestInter)
  }

  static String _getBaseUrl() {
    if (Platform.isWindows) {
      return "http://127.0.0.1:80/";
    } else {
      return "http://192.168.0.124:80/";
    }
  }

  Future<Resp> _request(
    String path, {
    required String method,
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
  }) async {
    try {
      Logger.debug(TAG, "request $path, params=$params, data=$data");
      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: params,
        options: Options(method: method),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          Map<String, dynamic> map = response.data;
          Resp resp = Resp.fromJson(map);
          Logger.debug(TAG, "response $path, resp=${resp.toJson()}");
          return resp;
        } catch (e) {
          return Future.error(ErrorInfo.PARSE_ERROR());
        }
      } else {
        // throw ErrorInfo.CUSTOME_ERROR(response.statusCode, _handleHttpError(response.statusCode!));
        return Future.error(ErrorInfo.CUSTOME_ERROR(response.statusCode, _handleHttpError(response.statusCode!)));
      }
    } on DioException catch (e) {
      //   throw ErrorInfo.CUSTOME_ERROR(e.type.index, _dioException(e));
      return Future.error(ErrorInfo.CUSTOME_ERROR(e.type.index, _dioException(e)));
    } catch (e) {
      return Future.error(ErrorInfo.CUSTOME_ERROR(2002, "未知错误"));
    }
  }

  // 处理 Dio 异常
  String _dioException(DioException exception) {
    String errorMsg = "网络异常";
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        errorMsg = "网络连接超时，请检查网络设置";
        break;
      case DioExceptionType.receiveTimeout:
        errorMsg = "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.sendTimeout:
        errorMsg = "网络连接超时，请检查网络设置";
        break;
      case DioExceptionType.badResponse:
        errorMsg = "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.cancel:
        errorMsg = "请求已被取消，请重新请求";
        break;
      case DioExceptionType.unknown:
        errorMsg = "网络异常，请稍后重试！";
        break;
      case DioExceptionType.connectionError:
        errorMsg = "服务器连接异常111";
        break;
      default:
        errorMsg = "Dio异常";
    }
    return errorMsg;
  }

  // 处理 Http 错误码
  String _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    Logger.error("HTTP", "_handleHttpError $message");
    return message;
  }

  Future<Resp> get(String path, {Map<String, dynamic>? params}) {
    return _request(path, method: 'GET', params: params);
  }

  Future<Resp> post(String path, {Map<String, dynamic>? params, data}) {
    return _request(path, method: 'POST', params: params, data: data);
  }
}

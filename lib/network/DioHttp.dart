import 'package:dio/dio.dart';

void testDio(Dio dio) async {
  Response response = await dio.get('https://www.wanandroid.com/banner/json');
  print(response.data.toString());
}

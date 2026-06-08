import 'package:dartz/dartz.dart';
import 'package:saku_pengeluaran/core/variable.dart';
import 'package:http/http.dart' as http;
import 'package:saku_pengeluaran/data/request/login_request_model.dart';
import 'package:saku_pengeluaran/data/response/Auth_response_model.dart';

class AuthRemoteDatasource {
  // ini function buat login 
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel data,
  ) async {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: data.toJson(),
    );

    if (response.statusCode == 200) {
      // right itu artinya success
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      // left itu artinya error
      return Left(response.body);
    }
  }
}
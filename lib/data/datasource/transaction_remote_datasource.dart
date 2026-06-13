import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:saku_pengeluaran/data/response/beri_pinjaman_response.dart';

import '../../core/variable.dart';
import 'auth_local_datasource.dart';

import '../request/wallet_request_model.dart';
import '../request/income_request_model.dart';
import '../request/outcome_request_model.dart';
import '../request/hutang_request_model.dart';
import '../request/beri_pinjaman_request_model.dart';

import '../response/wallet_response_model.dart';
import '../response/income_response_model.dart';
import '../response/outcome_response_model.dart';
import '../response/hutang_response_model.dart';
import '../response/category_response_model.dart';

class TransactionRemoteDatasource {
  // ================= CATEGORY =================

  Future<Either<String, CategoryResponseModel>> getIncomeCategory() async {
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/api/category-income'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        CategoryResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, CategoryResponseModel>> getOutcomeCategory() async {
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/api/category-outcome'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        CategoryResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  // ================= WALLET =================

  Future<Either<String, WalletResponseModel>> createWallet(
    WalletRequestModel model,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/wallet'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: model.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        WalletResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  // ================= INCOME =================

  Future<Either<String, IncomeResponseModel>> createIncome(
    IncomeRequestModel model,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/income'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: model.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        IncomeResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  // ================= OUTCOME =================

  Future<Either<String, OutcomeResponseModel>> createOutcome(
    OutcomeRequestModel model,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/outcome'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: model.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        OutcomeResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  // ================= HUTANG =================

  Future<Either<String, HutangResponseModel>> createHutang(
    HutangRequestModel model,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/hutang'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: model.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        HutangResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, HutangResponseModel>> updateStatusHutang(
    int id,
    String status,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.put(
      Uri.parse('${Variable.baseUrl}/api/hutang/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return Right(
        HutangResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  // ================= PINJAMAN =================

  Future<Either<String, BeriPinjamanResponseModel>> createBeriPinjaman(
    BeriPinjamanRequestModel model,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/beri-pinjaman'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: model.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        BeriPinjamanResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, BeriPinjamanResponseModel>> updateStatusBeriPinjaman(
    int id,
    String status,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.put(
      Uri.parse('${Variable.baseUrl}/api/beri-pinjaman/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return Right(
        BeriPinjamanResponseModel.fromJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }
}

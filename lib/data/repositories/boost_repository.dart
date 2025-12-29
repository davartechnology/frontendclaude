import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/boost_model.dart';

class BoostRepository {
  final Dio dio;

  BoostRepository(this.dio);

  Future<ApiResult<List<BoostPackageModel>>> getBoostPackages() async {
    try {
      final response = await dio.get(ApiConstants.boostPackages);
      final packages = (response.data['data'] as List)
          .map((json) => BoostPackageModel.fromJson(json))
          .toList();
      return Success(packages);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get boost packages'));
    }
  }

  Future<ApiResult<BoostModel>> purchaseBoost({
    required String videoId,
    required String packageId,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.purchaseBoost,
        data: {
          'videoId': videoId,
          'packageId': packageId,
        },
      );
      return Success(BoostModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to purchase boost'));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getBoostAnalytics(
    String videoId,
  ) async {
    try {
      final response = await dio.get(
        '${ApiConstants.boostAnalytics}/$videoId',
      );
      return Success(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get boost analytics'));
    }
  }
}
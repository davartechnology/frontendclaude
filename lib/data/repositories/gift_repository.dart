import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/gift_model.dart';

class GiftRepository {
  final Dio dio;

  GiftRepository(this.dio);

  Future<ApiResult<List<GiftModel>>> getGifts() async {
    try {
      final response = await dio.get(ApiConstants.gifts);
      final gifts = (response.data['data'] as List)
          .map((json) => GiftModel.fromJson(json))
          .toList();
      return Success(gifts);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get gifts'));
    }
  }

  Future<ApiResult<void>> purchaseGift({
    required String giftId,
    required int quantity,
  }) async {
    try {
      await dio.post(
        ApiConstants.purchaseGift,
        data: {
          'giftId': giftId,
          'quantity': quantity,
        },
      );
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to purchase gift'));
    }
  }

  Future<ApiResult<List<GiftTransactionModel>>> getGiftHistory() async {
    try {
      final response = await dio.get(ApiConstants.giftHistory);
      final transactions = (response.data['data'] as List)
          .map((json) => GiftTransactionModel.fromJson(json))
          .toList();
      return Success(transactions);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get gift history'));
    }
  }
}
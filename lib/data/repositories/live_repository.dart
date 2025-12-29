import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/live_stream_model.dart';

class LiveRepository {
  final Dio dio;

  LiveRepository(this.dio);

  Future<ApiResult<LiveStreamModel>> startLive(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        ApiConstants.goLive,
        data: data,
      );
      return Success(LiveStreamModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to start live stream'));
    }
  }

  Future<ApiResult<void>> endLive(String streamId) async {
    try {
      await dio.post('${ApiConstants.endLive}/$streamId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to end live stream'));
    }
  }

  Future<ApiResult<List<LiveStreamModel>>> getLiveStreams() async {
    try {
      final response = await dio.get(ApiConstants.liveStreams);
      final streams = (response.data['data'] as List)
          .map((json) => LiveStreamModel.fromJson(json))
          .toList();
      return Success(streams);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get live streams'));
    }
  }

  Future<ApiResult<LiveStreamModel>> joinLive(String streamId) async {
    try {
      final response = await dio.post('${ApiConstants.joinLive}/$streamId');
      return Success(LiveStreamModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to join live stream'));
    }
  }

  Future<ApiResult<void>> sendGift({
    required String streamId,
    required String giftId,
    required int amount,
  }) async {
    try {
      await dio.post(
        ApiConstants.sendGift,
        data: {
          'streamId': streamId,
          'giftId': giftId,
          'amount': amount,
        },
      );
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to send gift'));
    }
  }
}
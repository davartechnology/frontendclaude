import '../errors/failures.dart';

abstract class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  
  const Success(this.data);
}

class Error<T> extends ApiResult<T> {
  final Failure failure;
  
  const Error(this.failure);
}

extension ApiResultExtension<T> on ApiResult<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
  
  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;
  Failure? get failureOrNull => isError ? (this as Error<T>).failure : null;
  
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return error((this as Error<T>).failure);
    }
  }
  
  R? whenOrNull<R>({
    R Function(T data)? success,
    R Function(Failure failure)? error,
  }) {
    if (this is Success<T> && success != null) {
      return success((this as Success<T>).data);
    } else if (this is Error<T> && error != null) {
      return error((this as Error<T>).failure);
    }
    return null;
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers/auth_provider.dart';
import '../../core/services/api_service.dart';

// 1. Le provider pour Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://backendclaude-j98w.onrender.com',
  ));

  // INTERCEPTEUR : Ajoute le Bearer Token automatiquement
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final auth = ref.read(authProvider);
      if (auth.token != null) {
        options.headers['Authorization'] = 'Bearer ${auth.token}';
      }
      return handler.next(options);
    },
  ));
  
  return dio;
});

// 2. Le provider pour ApiService (Correction de l'erreur "Too few arguments")
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio); // On donne le dio au service
});
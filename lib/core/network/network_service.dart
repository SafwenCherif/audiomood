import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

enum NetworkFailureType { offline, timeout, server, unknown }

class NetworkException implements Exception {
  NetworkException(this.type, this.message);

  final NetworkFailureType type;
  final String message;

  @override
  String toString() => message;
}

class NetworkService {
  NetworkService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static const Duration defaultTimeout = Duration(seconds: 15);

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> ensureConnected() async {
    if (!await hasInternetConnection()) {
      throw NetworkException(
        NetworkFailureType.offline,
        'No internet connection. Please turn on Wi‑Fi or mobile data and try again.',
      );
    }
  }

  static NetworkException from(Object error) {
    if (error is NetworkException) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(
            NetworkFailureType.timeout,
            'The request timed out. The server took too long to respond. Please try again.',
          );
        case DioExceptionType.connectionError:
          return NetworkException(
            NetworkFailureType.offline,
            'Unable to reach the server. Check your internet connection and try again.',
          );
        default:
          return NetworkException(
            NetworkFailureType.server,
            'A network error occurred while contacting the server. Please try again later.',
          );
      }
    }

    if (error is TimeoutException) {
      return NetworkException(
        NetworkFailureType.timeout,
        'The operation timed out. Please check your connection and try again.',
      );
    }

    if (error is FirebaseException) {
      if (error.code == 'unavailable') {
        return NetworkException(
          NetworkFailureType.offline,
          'Cannot reach the database. Check your internet connection and try again.',
        );
      }
    }

    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection refused') ||
        text.contains('failed host lookup') ||
        text.contains('unavailable')) {
      return NetworkException(
        NetworkFailureType.offline,
        'No internet connection. Please check your network and try again.',
      );
    }

    return NetworkException(
      NetworkFailureType.unknown,
      'Something went wrong. Please try again.',
    );
  }
}

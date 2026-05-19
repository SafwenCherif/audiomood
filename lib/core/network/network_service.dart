import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

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

  Future<void> ensureConnected({Locale locale = const Locale('fr')}) async {
    if (!await hasInternetConnection()) {
      throw NetworkException(
        NetworkFailureType.offline,
        _messages(locale).errorNoInternet,
      );
    }
  }

  static AppLocalizations _messages(Locale locale) {
    return lookupAppLocalizations(locale);
  }

  static NetworkException from(Object error, {Locale locale = const Locale('fr')}) {
    if (error is NetworkException) return error;

    final l10n = _messages(locale);

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException(
            NetworkFailureType.timeout,
            l10n.errorTimeout,
          );
        case DioExceptionType.connectionError:
          return NetworkException(
            NetworkFailureType.offline,
            l10n.errorCannotReachServer,
          );
        default:
          return NetworkException(
            NetworkFailureType.server,
            l10n.errorServer,
          );
      }
    }

    if (error is TimeoutException) {
      return NetworkException(
        NetworkFailureType.timeout,
        l10n.errorOperationTimeout,
      );
    }

    if (error is FirebaseException) {
      if (error.code == 'unavailable') {
        return NetworkException(
          NetworkFailureType.offline,
          l10n.errorDatabaseUnavailable,
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
        l10n.errorNoInternetShort,
      );
    }

    return NetworkException(
      NetworkFailureType.unknown,
      l10n.errorSomethingWrong,
    );
  }
}

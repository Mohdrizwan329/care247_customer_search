import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/customer.dart';

/// Low-level HTTP client for the customers endpoint.
///
/// Throws [CustomerApiException] on network or parsing failures so that
/// higher layers can present user-friendly messages.
class CustomerApi {
  final http.Client _client;
  final String baseUrl;

  CustomerApi({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  /// Searches customers using the supplied criteria map.
  ///
  /// Keys match the FieldConfig keys (firstName, lastName, dateOfBirth, …).
  /// Empty / null values are omitted from the query so JSON Server only
  /// filters on the fields the user actually filled in.
  Future<List<Customer>> searchCustomers(Map<String, String> criteria) async {
    final queryParams = <String, String>{};
    criteria.forEach((key, value) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        queryParams[key] = trimmed;
      }
    });

    final uri = Uri.parse('$baseUrl${AppConfig.customersEndpoint}')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw CustomerApiException(
            'Unexpected response format from server.',
          );
        }
        return decoded
            .map((e) => Customer.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw CustomerApiException(
        'Server returned status ${response.statusCode}. Please try again.',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw CustomerApiException(
        'Unable to reach the server. Check that JSON Server is running and the API URL is correct.',
      );
    } on http.ClientException catch (e) {
      throw CustomerApiException(
        'Network error: ${e.message}',
      );
    } on FormatException {
      throw CustomerApiException(
        'Received invalid data from the server.',
      );
    } on CustomerApiException {
      rethrow;
    } catch (e) {
      throw CustomerApiException(
        'Something went wrong. Please try again later.',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class CustomerApiException implements Exception {
  final String message;
  final int? statusCode;

  CustomerApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

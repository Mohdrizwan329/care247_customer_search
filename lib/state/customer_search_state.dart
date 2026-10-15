import 'package:flutter/foundation.dart';

import '../data/customer_repository.dart';
import '../models/customer.dart';

/// Distinct UI states for the search / results flow.
enum SearchStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

/// Holds search criteria, results and status.
///
/// Uses [ChangeNotifier] (via Provider) so only listening widgets rebuild.
/// Controllers and focus nodes live in the form widget itself; this class
/// only owns business data.
class CustomerSearchState extends ChangeNotifier {
  final CustomerRepository _repository;

  SearchStatus _status = SearchStatus.initial;
  List<Customer> _customers = const [];
  String? _errorMessage;
  Map<String, String> _lastCriteria = const {};

  /// Guard against updating after dispose (async safety).
  bool _disposed = false;

  CustomerSearchState({CustomerRepository? repository})
      : _repository = repository ?? CustomerRepository();

  SearchStatus get status => _status;
  List<Customer> get customers => _customers;
  String? get errorMessage => _errorMessage;
  Map<String, String> get lastCriteria => Map.unmodifiable(_lastCriteria);
  bool get hasResults => _customers.isNotEmpty;

  Future<void> search(Map<String, String> criteria) async {
    if (_disposed) return;

    _lastCriteria = Map.from(criteria);
    _status = SearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.search(criteria);
      if (_disposed) return;

      _customers = results;
      _status = results.isEmpty ? SearchStatus.empty : SearchStatus.success;
      notifyListeners();
    } catch (e) {
      if (_disposed) return;
      _customers = const [];
      _status = SearchStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Re-run the last search (used by pull-to-refresh / retry).
  Future<void> refresh() async {
    if (_lastCriteria.isEmpty && _status == SearchStatus.initial) return;
    await search(_lastCriteria);
  }

  void clear() {
    if (_disposed) return;
    _status = SearchStatus.initial;
    _customers = const [];
    _errorMessage = null;
    _lastCriteria = const {};
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _repository.dispose();
    super.dispose();
  }
}

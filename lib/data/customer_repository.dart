import '../models/customer.dart';
import 'customer_api.dart';

/// Abstraction over [CustomerApi].
///
/// Keeps presentation / state layers free of direct HTTP knowledge and
/// makes unit testing straightforward (inject a fake repository).
class CustomerRepository {
  final CustomerApi _api;

  CustomerRepository({CustomerApi? api}) : _api = api ?? CustomerApi();

  Future<List<Customer>> search(Map<String, String> criteria) {
    return _api.searchCustomers(criteria);
  }

  void dispose() {
    _api.dispose();
  }
}

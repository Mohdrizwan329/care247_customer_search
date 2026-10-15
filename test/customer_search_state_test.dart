import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/data/customer_repository.dart';
import 'package:care247_customer_search/models/customer.dart';
import 'package:care247_customer_search/state/customer_search_state.dart';

class FakeRepository implements CustomerRepository {
  final List<Customer> results;
  final Exception? error;
  int callCount = 0;

  FakeRepository({this.results = const [], this.error});

  @override
  Future<List<Customer>> search(Map<String, String> criteria) async {
    callCount++;
    if (error != null) throw error!;
    return results;
  }

  @override
  void dispose() {}
}

Customer _sampleCustomer() => const Customer(
      id: '1',
      firstName: 'Alice',
      lastName: 'Johnson',
      dateOfBirth: '1985-03-15',
      maritalStatus: 'Married',
      secureId: 'SEC-1',
      addresses: [],
      phones: [],
      emails: [],
    );

void main() {
  group('CustomerSearchState', () {
    test('starts in initial status', () {
      final state = CustomerSearchState(
        repository: FakeRepository(),
      );
      expect(state.status, SearchStatus.initial);
      expect(state.customers, isEmpty);
      state.dispose();
    });

    test('transitions to success when results returned', () async {
      final state = CustomerSearchState(
        repository: FakeRepository(results: [_sampleCustomer()]),
      );
      await state.search({'firstName': 'Alice'});
      expect(state.status, SearchStatus.success);
      expect(state.customers.length, 1);
      expect(state.customers.first.firstName, 'Alice');
      state.dispose();
    });

    test('transitions to empty when no results', () async {
      final state = CustomerSearchState(
        repository: FakeRepository(results: []),
      );
      await state.search({'firstName': 'Nobody'});
      expect(state.status, SearchStatus.empty);
      expect(state.customers, isEmpty);
      state.dispose();
    });

    test('transitions to error on failure', () async {
      final state = CustomerSearchState(
        repository: FakeRepository(error: Exception('Network down')),
      );
      await state.search({'firstName': 'Alice'});
      expect(state.status, SearchStatus.error);
      expect(state.errorMessage, isNotNull);
      state.dispose();
    });

    test('clear resets to initial', () async {
      final state = CustomerSearchState(
        repository: FakeRepository(results: [_sampleCustomer()]),
      );
      await state.search({'firstName': 'Alice'});
      state.clear();
      expect(state.status, SearchStatus.initial);
      expect(state.customers, isEmpty);
      state.dispose();
    });
  });
}

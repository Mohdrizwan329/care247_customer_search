import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/models/customer.dart';

void main() {
  group('Customer.fromJson', () {
    test('parses complete customer JSON', () {
      final json = {
        'id': '1',
        'firstName': 'Alice',
        'lastName': 'Johnson',
        'dateOfBirth': '1985-03-15',
        'maritalStatus': 'Married',
        'secureId': 'SEC-1001',
        'addresses': [
          {
            'id': 'a1',
            'type': 'Home',
            'street': '123 Maple',
            'city': 'Springfield',
            'state': 'IL',
            'zipCode': '62701',
          }
        ],
        'phones': [
          {
            'id': 'p1',
            'type': 'Mobile',
            'number': '+1-555-0101',
            'isPrimary': true,
          }
        ],
        'emails': [
          {
            'id': 'e1',
            'type': 'Personal',
            'address': 'alice@email.com',
            'isPrimary': true,
          }
        ],
      };

      final customer = Customer.fromJson(json);

      expect(customer.id, '1');
      expect(customer.firstName, 'Alice');
      expect(customer.lastName, 'Johnson');
      expect(customer.fullName, 'Alice Johnson');
      expect(customer.dateOfBirth, '1985-03-15');
      expect(customer.maritalStatus, 'Married');
      expect(customer.secureId, 'SEC-1001');
      expect(customer.addresses.length, 1);
      expect(customer.addresses.first.type, 'Home');
      expect(customer.phones.length, 1);
      expect(customer.primaryPhone?.number, '+1-555-0101');
      expect(customer.emails.length, 1);
      expect(customer.primaryEmail?.address, 'alice@email.com');
    });

    test('handles missing nested lists gracefully', () {
      final json = {
        'id': '2',
        'firstName': 'Bob',
        'lastName': 'Smith',
        'dateOfBirth': '1990-01-01',
        'maritalStatus': 'Single',
        'secureId': 'SEC-2',
      };

      final customer = Customer.fromJson(json);
      expect(customer.addresses, isEmpty);
      expect(customer.phones, isEmpty);
      expect(customer.emails, isEmpty);
      expect(customer.primaryPhone, isNull);
      expect(customer.primaryEmail, isNull);
    });
  });
}

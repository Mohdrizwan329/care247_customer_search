import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/models/customer.dart';
import 'package:care247_customer_search/models/email.dart';
import 'package:care247_customer_search/models/phone.dart';
import 'package:care247_customer_search/widgets/customer_list_item.dart';

void main() {
  testWidgets('CustomerListItem displays name, DOB, primary phone & email',
      (tester) async {
    final customer = Customer(
      id: '1',
      firstName: 'Alice',
      lastName: 'Johnson',
      dateOfBirth: '1985-03-15',
      maritalStatus: 'Married',
      secureId: 'SEC-1',
      addresses: const [],
      phones: const [
        Phone(
          id: 'p1',
          type: 'Mobile',
          number: '+1-555-0101',
          isPrimary: true,
        ),
      ],
      emails: const [
        Email(
          id: 'e1',
          type: 'Personal',
          address: 'alice@email.com',
          isPrimary: true,
        ),
      ],
    );

    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomerListItem(
            customer: customer,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Alice Johnson'), findsOneWidget);
    expect(find.text('1985-03-15'), findsOneWidget);
    expect(find.text('+1-555-0101'), findsOneWidget);
    expect(find.text('alice@email.com'), findsOneWidget);
    expect(find.text('AJ'), findsOneWidget); // initials

    await tester.tap(find.byType(CustomerListItem));
    expect(tapped, isTrue);
  });
}

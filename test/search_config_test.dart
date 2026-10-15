import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/config/search_config.dart';

void main() {
  group('Search configuration', () {
    test('contains required fields in correct order', () {
      final ordered = orderedSearchConfig;
      expect(ordered.length, greaterThanOrEqualTo(3));
      expect(ordered.map((f) => f.key).toList(),
          containsAll(['firstName', 'lastName', 'dateOfBirth']));
      // Sorted by renderOrder
      for (var i = 0; i < ordered.length - 1; i++) {
        expect(ordered[i].renderOrder,
            lessThanOrEqualTo(ordered[i + 1].renderOrder));
      }
    });

    test('field types are correct', () {
      final firstName =
          searchConfig.firstWhere((f) => f.key == 'firstName');
      final dob =
          searchConfig.firstWhere((f) => f.key == 'dateOfBirth');
      expect(firstName.type, FieldType.text);
      expect(dob.type, FieldType.date);
    });

    test('adding a new field is reflected in ordered list', () {
      // Demonstrates extensibility without changing form code.
      final extended = [
        ...searchConfig,
        const FieldConfig(
          key: 'maritalStatus',
          type: FieldType.text,
          label: 'Marital Status',
          placeholder: 'e.g. Single',
          renderOrder: 4,
        ),
      ];
      final sorted = List<FieldConfig>.from(extended)
        ..sort((a, b) => a.renderOrder.compareTo(b.renderOrder));
      expect(sorted.last.key, 'maritalStatus');
      expect(sorted.length, searchConfig.length + 1);
    });
  });
}

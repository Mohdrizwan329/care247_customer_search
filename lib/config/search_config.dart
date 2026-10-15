/// Configuration-driven search form definitions.
///
/// Adding a new search field only requires appending a [FieldConfig]
/// entry here. The form UI, state collection and API query building
/// remain unchanged.

enum FieldType {
  text,
  date,
}

class FieldConfig {
  final String key;
  final FieldType type;
  final String label;
  final String? placeholder;
  final int renderOrder;

  const FieldConfig({
    required this.key,
    required this.type,
    required this.label,
    this.placeholder,
    required this.renderOrder,
  });
}

/// Canonical search configuration used by the Search screen.
///
/// To add a new field (e.g. Marital Status) simply append another
/// [FieldConfig]. The DynamicSearchForm will render it automatically
/// according to [renderOrder].
final List<FieldConfig> searchConfig = [
  const FieldConfig(
    key: 'firstName',
    type: FieldType.text,
    label: 'First Name',
    placeholder: 'Enter first name',
    renderOrder: 1,
  ),
  const FieldConfig(
    key: 'lastName',
    type: FieldType.text,
    label: 'Last Name',
    placeholder: 'Enter last name',
    renderOrder: 2,
  ),
  const FieldConfig(
    key: 'dateOfBirth',
    type: FieldType.date,
    label: 'Date of Birth',
    placeholder: 'Select date of birth',
    renderOrder: 3,
  ),
  // Example of how to add a new field without touching form widgets:
  // const FieldConfig(
  //   key: 'maritalStatus',
  //   type: FieldType.text,
  //   label: 'Marital Status',
  //   placeholder: 'e.g. Single, Married',
  //   renderOrder: 4,
  // ),
];

/// Returns the configuration sorted by [renderOrder].
List<FieldConfig> get orderedSearchConfig {
  final list = List<FieldConfig>.from(searchConfig);
  list.sort((a, b) => a.renderOrder.compareTo(b.renderOrder));
  return list;
}

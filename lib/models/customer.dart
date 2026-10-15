import 'address.dart';
import 'email.dart';
import 'phone.dart';

class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String maritalStatus;
  final String secureId;
  final List<Address> addresses;
  final List<Phone> phones;
  final List<Email> emails;

  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.secureId,
    required this.addresses,
    required this.phones,
    required this.emails,
  });

  String get fullName => '$firstName $lastName';

  Phone? get primaryPhone {
    try {
      return phones.firstWhere((p) => p.isPrimary);
    } catch (_) {
      return phones.isNotEmpty ? phones.first : null;
    }
  }

  Email? get primaryEmail {
    try {
      return emails.firstWhere((e) => e.isPrimary);
    } catch (_) {
      return emails.isNotEmpty ? emails.first : null;
    }
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      dateOfBirth: json['dateOfBirth']?.toString() ?? '',
      maritalStatus: json['maritalStatus']?.toString() ?? '',
      secureId: json['secureId']?.toString() ?? '',
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => Phone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      emails: (json['emails'] as List<dynamic>?)
              ?.map((e) => Email.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'maritalStatus': maritalStatus,
        'secureId': secureId,
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'phones': phones.map((p) => p.toJson()).toList(),
        'emails': emails.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

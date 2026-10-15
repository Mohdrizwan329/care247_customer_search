class Email {
  final String id;
  final String type;
  final String address;
  final bool isPrimary;

  const Email({
    required this.id,
    required this.type,
    required this.address,
    required this.isPrimary,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      isPrimary: json['isPrimary'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'address': address,
        'isPrimary': isPrimary,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Phone {
  final String id;
  final String type;
  final String number;
  final bool isPrimary;

  const Phone({
    required this.id,
    required this.type,
    required this.number,
    required this.isPrimary,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      isPrimary: json['isPrimary'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'number': number,
        'isPrimary': isPrimary,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Phone && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VratItem {
  final String id;
  final String name;
  final String hindiName;
  final DateTime date;
  final String type; // Ekadashi, Pradosh, Chaturthi, Purnima, Amavasya, Somwar
  final String deity;
  final String paranaTiming;
  final String significance;
  final String kathaTitle;
  final String kathaContent;
  final List<String> rules;

  const VratItem({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.date,
    required this.type,
    required this.deity,
    required this.paranaTiming,
    required this.significance,
    required this.kathaTitle,
    required this.kathaContent,
    required this.rules,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hindiName': hindiName,
    'date': date.toIso8601String(),
    'type': type,
    'deity': deity,
    'paranaTiming': paranaTiming,
    'significance': significance,
    'kathaTitle': kathaTitle,
    'kathaContent': kathaContent,
    'rules': rules,
  };

  factory VratItem.fromJson(Map<String, dynamic> json) {
    return VratItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      hindiName: json['hindiName']?.toString() ?? '',
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.now(),
      type: json['type']?.toString() ?? 'Ekadashi',
      deity: json['deity']?.toString() ?? 'Lord Vishnu',
      paranaTiming: json['paranaTiming']?.toString() ?? '',
      significance: json['significance']?.toString() ?? '',
      kathaTitle: json['kathaTitle']?.toString() ?? '',
      kathaContent: json['kathaContent']?.toString() ?? '',
      rules: (json['rules'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

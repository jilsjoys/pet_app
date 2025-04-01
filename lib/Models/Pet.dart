// ignore_for_file: file_names

class Pet {
  int? id;
  String name;
  String category;
  int? age;
  String? date;
  int? heartRate;
  int? pulseRate;
  int? respRate;
  String? imageUrl;
  String? vaccinateDate; // Nullable field for vaccination date
  String? vaccinationName;

  Pet({
    required this.id,
    required this.name,
    required this.category,
    this.age,
    this.date,
    this.heartRate,
    this.pulseRate,
    this.respRate,
    this.imageUrl,
    this.vaccinateDate,
    this.vaccinationName,
  });
}

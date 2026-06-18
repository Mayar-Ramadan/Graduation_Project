class WaterReadingModel {
  final double amount;
  final double remainingAmount;
  final String status;
  final String time;
  final String date;
  final int createdAt;

  WaterReadingModel({
    required this.amount,
    required this.remainingAmount,
    required this.status,
    required this.time,
    required this.date,
    required this.createdAt,
  });

  factory WaterReadingModel.fromMap(Map<String, dynamic> map) {
    return WaterReadingModel(
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (map['remainingAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      time: map['time'] ?? '',
      date: map['date'] ?? '',
      createdAt: map['createdAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'remainingAmount': remainingAmount,
      'time': time,
      'date': date,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
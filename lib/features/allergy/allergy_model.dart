// lib/features/allergy/allergy_model.dart
class AllergyTest {
  final int id;
  final String testDate;
  final String emoji;
  final String ingredientName;
  final String memo;
  final String? status; // '통과' | '보류' | '다시'

  const AllergyTest({
    required this.id,
    required this.testDate,
    required this.emoji,
    required this.ingredientName,
    required this.memo,
    this.status,
  });

  factory AllergyTest.fromJson(Map<String, dynamic> j) => AllergyTest(
        id: j['id'],
        testDate: j['test_date'] ?? '',
        emoji: j['emoji'] ?? '🧪',
        ingredientName: j['ingredient_name'] ?? '',
        memo: j['memo'] ?? '',
        status: j['status'],
      );
}

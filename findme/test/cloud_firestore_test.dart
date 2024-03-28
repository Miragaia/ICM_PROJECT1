import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('Firestore Setup', () {
    test('Firestore instance is initialized', () {
      // Initialize Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Verify if the Firestore instance is not null
      expect(firestore, isNotNull);
    });
  });
}

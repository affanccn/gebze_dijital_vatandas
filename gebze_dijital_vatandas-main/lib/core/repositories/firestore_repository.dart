import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream weather data
  Stream<Map<String, dynamic>?> watchWeather() {
    return _firestore
        .collection('gebze')
        .doc('weather')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  // Stream pharmacies data
  Stream<Map<String, dynamic>?> watchPharmacies() {
    return _firestore
        .collection('gebze')
        .doc('pharmacies')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  // Stream water outages
  Stream<Map<String, dynamic>?> watchWaterOutages() {
    return _firestore
        .collection('gebze')
        .doc('waterOutages')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  // Stream power outages
  Stream<Map<String, dynamic>?> watchPowerOutages() {
    return _firestore
        .collection('gebze')
        .doc('powerOutages')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository();
});

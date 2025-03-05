import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contour/contour.dart';

class FirestoreCollection {
  const FirestoreCollection({required this.name, required this.schema});

  final String name;
  final ContourObject schema;

  /// Get a reference to this Firestore collection
  CollectionReference get reference =>
      FirebaseFirestore.instance.collection(name);

  /// Convert a Firestore document to a schema-compliant object
  Map<String, dynamic> toSchemaObject(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return {};

    return _convertToSchema(data);
  }

  /// Convert a list of Firestore documents to schema-compliant objects
  List<Map<String, dynamic>> toSchemaObjects(List<DocumentSnapshot> docs) {
    return docs.map(toSchemaObject).toList();
  }

  /// Convert QuerySnapshot to schema-compliant objects
  List<Map<String, dynamic>> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => toSchemaObject(doc)).toList();
  }

  /// Map a document's data according to the schema
  Map<String, dynamic> _convertToSchema(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    // Use schema to convert document data to appropriate types
    for (final field in schema.schema.entries) {
      final key = field.key;
      final type = field.value;

      if (data.containsKey(key)) {
        result[key] = _convertValueByType(data[key], type);
      }
    }

    return result;
  }

  /// Convert a value based on its ContourType
  dynamic _convertValueByType(dynamic value, ContourType type) {
    if (value == null) return null;

    if (type is ContourObject) {
      if (value is Map<String, dynamic>) {
        return _convertToSchema(value);
      }
      return {};
    } else if (type is ContourList) {
      if (value is List) {
        return value
            .map((item) => _convertValueByType(item, type.item))
            .toList();
      }
      return [];
    } else if (type is ContourString) {
      return value.toString();
    } else if (type is ContourBoolean) {
      return value is bool ? value : (value == 'true');
    } else if (type is ContourNumber) {
      return value is num ? value : num.tryParse(value.toString()) ?? 0;
    } else if (value is Timestamp) {
      // Handle Firestore Timestamp specifically
      return value.toDate();
    }

    // Default case, return as is
    return value;
  }

  /// Stream documents from this collection converted to schema format
  Stream<List<Map<String, dynamic>>> streamDocuments({Query? query}) {
    final collectionQuery = query ?? reference;
    return collectionQuery.snapshots().map(fromQuerySnapshot);
  }

  /// Get documents from this collection converted to schema format
  Future<List<Map<String, dynamic>>> getDocuments({Query? query}) async {
    final collectionQuery = query ?? reference;
    final snapshot = await collectionQuery.get();
    return fromQuerySnapshot(snapshot);
  }

  /// Get a single document by ID converted to schema format
  Future<Map<String, dynamic>> getDocument(String id) async {
    final docSnapshot = await reference.doc(id).get();
    return toSchemaObject(docSnapshot);
  }
}

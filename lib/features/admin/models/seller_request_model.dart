import 'package:cloud_firestore/cloud_firestore.dart';

enum SellerRequestStatus { pending, approved, rejected }

class SellerRequestModel {
  final String id;
  final String userId;
  final String specialty;
  final String description;
  final String? idDocument;
  final SellerRequestStatus status;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;

  const SellerRequestModel({
    this.id = '',
    required this.userId,
    required this.specialty,
    this.description = '',
    this.idDocument,
    this.status = SellerRequestStatus.pending,
    this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'specialty': specialty,
        'description': description,
        'idDocument': idDocument,
        'status': status.name,
        'submittedAt':
            submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
        'reviewedAt':
            reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
        'reviewedBy': reviewedBy,
      };

  factory SellerRequestModel.fromJson(Map<String, dynamic> json,
      {String? id}) {
    return SellerRequestModel(
      id: id ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      specialty: json['specialty'] ?? '',
      description: json['description'] ?? '',
      idDocument: json['idDocument'],
      status: SellerRequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SellerRequestStatus.pending,
      ),
      submittedAt: (json['submittedAt'] as Timestamp?)?.toDate(),
      reviewedAt: (json['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: json['reviewedBy'],
    );
  }
}

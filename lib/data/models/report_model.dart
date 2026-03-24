import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String address;
  final String status; // pending, in_progress, resolved, rejected
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int upvotes;
  final int comments;

  ReportModel({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
    this.upvotes = 0,
    this.comments = 0,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'description': description,
    'category': category,
    'imageUrl': imageUrl,
    'location': GeoPoint(latitude, longitude),
    'address': address,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'upvotes': upvotes,
    'comments': comments,
  };

  factory ReportModel.fromJson(Map<String, dynamic> json, String id) => ReportModel(
    id: id,
    userId: json['userId'],
    title: json['title'],
    description: json['description'],
    category: json['category'],
    imageUrl: json['imageUrl'],
    latitude: (json['location'] as GeoPoint).latitude,
    longitude: (json['location'] as GeoPoint).longitude,
    address: json['address'],
    status: json['status'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    updatedAt: json['updatedAt'] != null 
        ? (json['updatedAt'] as Timestamp).toDate() 
        : null,
    upvotes: json['upvotes'] ?? 0,
    comments: json['comments'] ?? 0,
  );
}
// vive_huanchaco/lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? email;
  final String? fullName; // [cite: 1]
  final String? lastName; // [cite: 1]
  final DateTime? dateOfBirth; // [cite: 1]
  final String? gender;
  final String? country; 

  const User({
    required this.id,
    this.email,
    this.fullName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.country,
  });

  @override
  List<Object?> get props => [id, email, fullName, lastName, dateOfBirth, gender, country];
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.fullName,
  });

  factory AuthUserModel.fromSupabaseUser(User user) {
    final fullName =
        (user.userMetadata?['full_name'] as String?)?.trim() ?? '';
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: fullName,
    );
  }
}

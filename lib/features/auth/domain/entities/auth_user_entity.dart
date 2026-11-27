class AuthUserEntity {
  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
  });

  final String id;
  final String email;
  final String fullName;
}

class AuthResultEntity {
  const AuthResultEntity({
    required this.user,
    required this.hasActiveSession,
  });

  final AuthUserEntity? user;
  final bool hasActiveSession;
}

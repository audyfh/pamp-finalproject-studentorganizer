import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: const Padding(
        padding: AppSpacing.screenPadding,
        child: Center(
          child: Text('Placeholder Halaman Registrasi (Fondasi Auth)'),
        ),
      ),
    );
  }
}

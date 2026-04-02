import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitConnect')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏋️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Bem-vindo ao FitConnect!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'Conectando trainers e clientes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Modular.to.navigate('/signup'),
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

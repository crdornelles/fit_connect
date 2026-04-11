import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../models/deep_link_data.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _referralCodeController = TextEditingController();
  bool _cameFromDeepLink = false;

  @override
  void initState() {
    super.initState();
    final args = Modular.args.data;
    if (args is DeepLinkData && args.referralCode != null) {
      _referralCodeController.text = args.referralCode!;
      _cameFromDeepLink = true;
    }
  }

  @override
  void dispose() {
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🏋️',
              style: TextStyle(fontSize: 48),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _referralCodeController,
              decoration: InputDecoration(
                labelText: _cameFromDeepLink
                    ? 'Código de Indicação (via link)'
                    : 'Código de Indicação (opcional)',
                border: const OutlineInputBorder(),
                suffixIcon: _cameFromDeepLink
                    ? const Icon(Icons.link, color: Colors.green)
                    : null,
              ),
              maxLength: 20,
              enabled: true, // Sempre editável
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

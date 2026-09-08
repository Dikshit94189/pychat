import 'package:chatypy/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(
      authProvider,
          (previous, next) {
        if (next.user != null &&
            previous?.user == null) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const UsersScreen(),
            ),
          );
        }

        if (next.error != null &&
            next.error != previous?.error) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(next.error!),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () {
                ref
                    .read(authProvider.notifier)
                    .login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
              },
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
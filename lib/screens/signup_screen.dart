import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  String? _nameValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Enter full name';
    }
    if (v.trim().length < 3) {
      return 'Name too short';
    }
    return null;
  }

  String? _phoneValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Enter phone';
    }
    if (!RegExp(r'^[0-9]{7,15}$').hasMatch(v)) {
      return 'Enter valid phone digits (7-15)';
    }
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Enter email';
    }
    final parts = v.split('@');
    if (parts.length != 2 || !parts[1].contains('.')) {
      return 'Enter valid email';
    }
    return null;
  }

  String? _pwValidator(String? v) {
    if (v == null || v.isEmpty) {
      return 'Enter password';
    }
    if (v.length < 6) {
      return 'Minimum 6 characters';
    }
    return null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      
      // 1. Perform Signup
      await auth.signUp(
        email: _email.text.trim(),
        password: _password.text.trim(),
        name: _name.text.trim(),
        phone: _phone.text.trim(),
      );

      // 2. Sign out immediately so they aren't auto-logged in
      await auth.signOut();

      if (!mounted) return;
      setState(() => _loading = false);

      // 3. Show Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );

      // 4. Redirect to Login and remove signup from history
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C5CE7), Color(0xFF00B894)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Freshify',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Get started',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _name,
                                decoration: InputDecoration(
                                  labelText: 'Full name',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: _nameValidator,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: _phoneValidator,
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: _emailValidator,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _password,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: _pwValidator,
                                obscureText: true,
                              ),
                              const SizedBox(height: 22),
                              _buildSubmitButton(),
                              const SizedBox(height: 14),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Already have an account? Log in'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF00B894)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Create account', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
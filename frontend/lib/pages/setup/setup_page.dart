import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ringly/services/settings_service.dart';

@RoutePage()
class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _backendUrlController = TextEditingController(text: 'http://localhost:8800');
  bool _isLoading = false;

  Future<void> _completeSetup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Save API configuration
        await settingsServiceSingleton.setApiConfig({
          'backendUrl': _backendUrlController.text,
        });

        // Mark setup as completed
        await settingsServiceSingleton.setSetupCompleted(true);

        if (mounted) {
          context.router.replaceNamed('/auth');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _backendUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.settings,
                  size: 64,
                  color: Color(0xFF6B4EFF),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Ringly',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Let\'s set up your call attribution system',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Backend Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _backendUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Backend URL',
                    hintText: 'http://localhost:8800',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the backend URL';
                    }
                    if (!value.startsWith('http')) {
                      return 'URL must start with http:// or https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Complete Setup'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

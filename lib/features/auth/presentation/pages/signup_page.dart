// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_event.dart';
// import '../bloc/auth_state.dart';
//
// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});
//
//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   final _name = TextEditingController();
//   final _email = TextEditingController();
//   final _password = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthAuthenticated) {
//             Navigator.pushReplacementNamed(context, '/home');
//           }
//           if (state is AuthError) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Create Account',
//                       style: Theme.of(context).textTheme.headlineMedium),
//                   const SizedBox(height: 24),
//                   TextFormField(
//                     controller: _name,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                     validator: (v) =>
//                     v!.isNotEmpty ? null : 'Name required',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _email,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                     validator: (v) =>
//                     v!.contains('@') ? null : 'Invalid email',
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _password,
//                     decoration: const InputDecoration(labelText: 'Password'),
//                     obscureText: true,
//                     validator: (v) =>
//                     v!.length >= 6 ? null : 'Min 6 characters',
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: state is AuthLoading
//                           ? null
//                           : () {
//                         if (_formKey.currentState!.validate()) {
//                           context.read<AuthBloc>().add(
//                             SignupRequested(
//                               _name.text.trim(),
//                               _email.text.trim(),
//                               _password.text.trim(),
//                             ),
//                           );
//                         }
//                       },
//                       child: state is AuthLoading
//                           ? const CircularProgressIndicator()
//                           : const Text('Sign Up'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔙 Back
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 16),

                    /// 🧾 Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Join our e-commerce community today',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 32),

                    _label('Full Name'),
                    _input(
                      controller: _name,
                      hint: 'John Doe',
                      icon: Icons.person_outline,
                      validator: (v) =>
                      v!.isNotEmpty ? null : 'Name required',
                    ),

                    const SizedBox(height: 20),

                    _label('Email'),
                    _input(
                      controller: _email,
                      hint: 'example@email.com',
                      icon: Icons.email_outlined,
                      validator: (v) =>
                      v!.contains('@') ? null : 'Invalid email',
                    ),

                    const SizedBox(height: 20),

                    _label('Password'),
                    _input(
                      controller: _password,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffix: _eye(
                        _obscurePassword,
                            () => setState(
                                () => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) =>
                      v!.length >= 6 ? null : 'Min 6 characters',
                    ),

                    const SizedBox(height: 20),

                    _label('Confirm Password'),
                    _input(
                      controller: _confirmPassword,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: _obscureConfirm,
                      suffix: _eye(
                        _obscureConfirm,
                            () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (v) =>
                      v == _password.text ? null : 'Passwords do not match',
                    ),

                    const SizedBox(height: 20),

                    /// ☑ Terms
                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          onChanged: (v) =>
                              setState(() => _agree = v ?? false),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              children: [
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: const TextStyle(
                                    color: Color(0xFF14B8A6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// 🚀 Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF14B8A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        onPressed: !_agree || state is AuthLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              SignupRequested(
                                _name.text.trim(),
                                _email.text.trim(),
                                _password.text.trim(),
                              ),
                            );
                          }
                        },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// 🔁 Login
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Color(0xFF14B8A6),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------- Helpers ----------
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );

  Widget _eye(bool value, VoidCallback onTap) => IconButton(
    icon: Icon(
      value ? Icons.visibility_off : Icons.visibility,
      color: Colors.grey,
    ),
    onPressed: onTap,
  );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffix,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF14B8A6)),
        ),
      ),
    );
  }
}

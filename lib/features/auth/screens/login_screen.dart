import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withOpacity(0.05),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  
                  // Logo / Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_stories, size: 48, color: AppTheme.primaryBlue),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900, 
                      color: AppTheme.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your mobile number to explore professional courses and tests.",
                    style: TextStyle(fontSize: 15, color: AppTheme.textGrey, height: 1.5),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Label
                  const Text(
                    "Mobile Number",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 12),
                  
                  // Phone Input
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.bgLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.textGrey.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          "+91", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)
                        ),
                        const SizedBox(width: 16),
                        Container(height: 24, width: 1.5, color: AppTheme.textGrey.withOpacity(0.3)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: "98765 43210",
                              hintStyle: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.normal),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_phoneController.text.length == 10) {
                        context.push('/otp', extra: _phoneController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid 10-digit number"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Continue with OTP"),
                  ),

                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16), 
                        child: Text("OR", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 12))
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // Alternative Login
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text("Continue with Google"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      side: BorderSide(color: AppTheme.textGrey.withOpacity(0.25)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      foregroundColor: AppTheme.textDark,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New to EduGuru?", style: TextStyle(color: AppTheme.textGrey)),
                        TextButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text(
                            "Create Account", 
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

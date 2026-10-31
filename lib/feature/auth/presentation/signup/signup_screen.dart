import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuqta/core/helper/validators.dart';
import 'package:nuqta/core/routes/routes.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:nuqta/core/theme/app_text_styles.dart';
import 'package:nuqta/core/widget/app_primary_button.dart';
import 'package:nuqta/feature/auth/data/auth_service.dart';
import 'package:nuqta/feature/auth/domain/auth_exception.dart';
import 'package:nuqta/feature/auth/presentation/widget/form_field.dart';
import 'package:sizer/sizer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await _authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
        sendVerification: false,
      );

      if (!mounted) return;

      final user = credential.user;
      final userId = user?.email ?? user?.uid ?? _emailController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeScreen,
        (route) => false,
        arguments: userId,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up failed: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: 100.w, height: 100.h),
          SvgPicture.asset(
            'assets/svg/login_background.svg',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2.h),
                    SvgPicture.asset('assets/svg/app_logo.svg', height: 8.h),
                    SizedBox(height: 2.h),
                    Text(
                      'Create Account',
                      style: AppTextStyles.notoSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Join Nuqta today',
                      style: AppTextStyles.notoSans(
                        fontSize: 13.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Name field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextFormField(
                        label: 'Full Name',
                        hintText: 'John Doe',
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: Validators.validateName,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Email field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextFormField(
                        label: 'Email address',
                        hintText: 'name@example.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: Validators.validateEmail,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Password field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextFormField(
                        label: 'Password',
                        hintText: 'Min 8 chars, 1 uppercase, 1 symbol',
                        obscureText: isPasswordVisible,
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                        ),
                        prefixIcon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Confirm Password field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextFormField(
                        label: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        obscureText: isConfirmPasswordVisible,
                        controller: _confirmPasswordController,
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                        ),
                        prefixIcon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Submit button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: AppPrimaryButton(
                        title: 'Sign Up',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _handleSignup,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Already have an account row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.notoSans(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: AppTextStyles.notoSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forgetPasswordColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

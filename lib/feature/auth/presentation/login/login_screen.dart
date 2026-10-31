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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isPasswordVisible = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      final user = credential.user;
      final userId = user?.email ?? user?.uid ?? _emailController.text.trim();

      Navigator.pushReplacementNamed(
        context,
        Routes.homeScreen,
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
          content: Text('Login failed: ${e.toString()}'),
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
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/app_logo.svg', height: 8.h),
                    SizedBox(height: 3.h),
                    Text(
                      'Nuqta',
                      style: AppTextStyles.notoSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Know what's open before you go.",
                      style: AppTextStyles.notoSansArabic(fontSize: 15.sp),
                    ),
                    SizedBox(height: 1.h),
                    SvgPicture.asset(
                      "assets/svg/service Micro-Indicators.svg",
                      height: 5.h,
                    ),
                    SizedBox(height: 5.h),

                    // email and text field
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
                    // password and text field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CustomTextFormField(
                        label: 'Password',
                        hintText: 'secretPass123',
                        obscureText: isPasswordVisible,
                        controller: _passwordController,
                        validator: Validators.validateLoginPassword,
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

                        forgetPassword: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password reset feature coming soon.',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Forget Password?",
                            style: AppTextStyles.notoSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.forgetPasswordColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // auth button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: AppPrimaryButton(
                        title: 'Login',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _handleLogin,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.notoSans(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.signupScreen);
                          },
                          child: Text(
                            "Sign Up",
                            style: AppTextStyles.notoSans(
                              fontSize: 14.sp,
                              color: AppColors.forgetPasswordColor,
                            ),
                          ),
                        ),
                      ],
                    ),
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

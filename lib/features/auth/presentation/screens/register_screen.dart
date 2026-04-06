import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/extension/email_validation.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/buttom_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/q_text.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/register_toggle.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text1.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/widgets/text2.dart';

class RegisterScreen extends StatefulWidget {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedIndex = 0;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        leading: Icon(Icons.arrow_back_ios_new, color: primaryColor),
        title: Text(
          'Create Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: widget._formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text1(text1: 'Join Ayady'),
                SizedBox(height: 15),
                Text2(text2: 'Experience the elegance of handcrafted items'),
                SizedBox(height: 15),
                Customtextfield(label: 'Full Name', hintText: 'JohnDoe'),
                SizedBox(height: 10),
                Customtextfield(
                  controller: widget._emailController,
                  label: 'EMAIL ADDRESS',
                  hintText: 'example@mail.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.emailValid()) {
                      return "Email isn't valid";
                    }
                    ;
                  },
                ),
                SizedBox(height: 10),

                Customtextfield(
                  controller: widget._passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password should be more than 5 letters";
                    }
                    return null;
                  },
                  label: 'Password',
                ),
                SizedBox(height: 15),
                Text2(text2: 'Register as:'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: backGroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  //  child:Row(
                  //     children: [
                  //       Expanded(
                  //         child: GestureDetector(
                  //          onTap: () {
                  //            setState(() {
                  //          selectedIndex = 0;
                  //           });
                  //             },
                  //         child: Container(
                  //           padding: EdgeInsets.only(top: 8 ,bottom: 8 ),
                  //           decoration: BoxDecoration(
                  //             color:selectedIndex==0
                  //             ?Colors.white
                  //             :Colors.transparent,
                  //             borderRadius: BorderRadius.circular(6),
                  //           ),
                  //           child: Center(
                  //             child: Text('Customer',
                  //             style: TextStyle(color:selectedIndex==0
                  //             ?primaryColor
                  //             :Colors.grey,
                  //             fontWeight: FontWeight.w700
                  //             ,fontSize: 14),),
                  //           ),
                  //         ),
                  //       ),
                  //       ),
                  //       Expanded(
                  //         child: GestureDetector(
                  //          onTap: () {
                  //            setState(() {
                  //          selectedIndex = 1;
                  //           });
                  //             },

                  //         child: Container(
                  //           padding: EdgeInsets.only(top: 8 ,bottom: 8 ),
                  //           decoration: BoxDecoration(
                  //             color: selectedIndex==1
                  //             ?Colors.white
                  //             :Colors.transparent,
                  //             borderRadius: BorderRadius.circular(6),
                  //           ),
                  //           child:Center(
                  //             child: Text('Seller', style:
                  //             TextStyle(color: selectedIndex==1
                  //             ?primaryColor
                  //             :Colors.grey,
                  //             fontWeight: FontWeight.w700
                  //             ,fontSize: 14),),) ,
                  //         ))
                  //  )],)
                  // ),
                  child: RegisterToggle(
                    selectedIndex: selectedIndex,
                    onChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text2(
                        text2:
                            'I agree to the Terms of Service and Privacy Policy.',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CustomButton(text: 'Create Account', value: 'Create Account'),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QText(text: 'Already have an account?'),
                    SizedBox(width: 10),
                    ButtomText(text: 'Log In', value: 'Log In'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

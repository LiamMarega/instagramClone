import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void changeToLogIn() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const LoginScreen())));
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => const ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              )),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              //svg image
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),

              const SizedBox(height: 64),
              // circular widget to accept and show our selected file
              userAvatar(),
              const SizedBox(height: 25),
              //form register
              form(),
              const SizedBox(height: 25),

              const SizedBox(height: 25),
              //button login
              buttonLogin(),
              const SizedBox(height: 25),
              Flexible(child: Container(), flex: 2),
              //transition top sign up
              dontHaveAccount(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Row dontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: const Text(
            "Don't have an account?",
          ),
        ),
        GestureDetector(
          onTap: changeToLogIn,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: const Text(
              "Sign up",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  InkWell buttonLogin() {
    return InkWell(
      onTap: signUpUser,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            color: blueColor,
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : const Text('Sign Up')),
    );
  }

  Column form() {
    return Column(
      children: [
        TextFieldInput(
          hintText: 'Enter you username',
          textEditingController: _usernameController,
          textInputType: TextInputType.text,
        ),
        //text field for input email
        TextFieldInput(
          textEditingController: _emailController,
          hintText: 'Enter you email',
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 25),
        //text field for input password
        TextFieldInput(
          textEditingController: _passwordController,
          hintText: 'Enter you password',
          textInputType: TextInputType.text,
          isPass: true,
        ),
        const SizedBox(height: 25),
        //text field for bio
        TextFieldInput(
          hintText: 'Enter you bio',
          textEditingController: _bioController,
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  Stack userAvatar() {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 65,
                backgroundImage: MemoryImage(_image!),
              )
            : const CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(
                    'https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png'),
              ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        )
      ],
    );
  }
}

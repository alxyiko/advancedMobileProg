import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_nexus/main.dart';
import 'package:flutter/gestures.dart';
import 'FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {

  @override
  void initState() {
    // print(rootUser);
    // // final user = FirebaseAuth.instance.currentUser?.uid;
    // homeRoute = routeObserver.currentRoute;
    // // setUserData();
    // // print('user');
    // // // print(user);
    // if (rootUser != null){
    //   Navigator.pushNamed(context,'/home');
    // }

    // super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void loginNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Welcome to Barangay Nexus!')),
    );
      Navigator.pushNamed(context, '/home');
  }

  Future<void> _validateAndSubmit() async {
    String snacc = '';

    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (context) => const AlertDialog(
          contentPadding: EdgeInsets.all(40),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50, // Adjust width
                height: 50, // Adjust height
                child: CircularProgressIndicator(),
              ),
              SizedBox(height: 20),
              Text(
                'Please wait',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text("This will only take a moment..."), // Loading message
            ],
          ),
        ),
      );

      // Perform login
      final user =
          await loginUser(_emailController.text, _passwordController.text);

      Navigator.pop(context); // Close the loading dialog

      if (user != null) {
        loginNavigate(); // Navigate if login is successful
        return;
      } else {
        snacc = 'Wrong email or password!';
      }
    } else {
      snacc = 'Please try again!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snacc)),
    );
  }

  // Future<void> _validateAndSubmit() async {
  //   String snacc = '';

  //   if (_formKey.currentState!.validate()) {
  //     if (await loginUser(_emailController.text, _passwordController.text) !=
  //         null) {
  //       loginNavigate();
  //     } else {
  //       snacc = 'Wrong email or password!';
  //     }
  //   } else {
  //     snacc = 'Please try again!';
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(snacc)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 100,
                              child: Image.asset('assets/logo.png')),
                          // const Text(
                          //   'Barangay Nexus',
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // )
                        ],
                      ),
                    ),
                    const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFF3F4147),
                        fontSize: 24,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.60,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Welcome back! Let’s get you signed in.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF797B81),
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                        height: 1.03,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Enter email",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(0xFF797B81),
                                size: 22, // Change size here (default is 24)
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter an email!";
                              } else if (!emailRegex.hasMatch(value)) {
                                return "Please enter a valid email!";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: _obscureText, // Toggle text visibility
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Enter password",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFF797B81),
                                size: 22,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8), // Adjust spacing here
                                child: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF797B81),
                                    size: 22, // Adjusted size
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText =
                                          !_obscureText; // Toggle state
                                    });
                                  },
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a password!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity, // Takes full width
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _validateAndSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF006644), // Button background
                                foregroundColor: Colors.white, // Text color
                                textStyle: const TextStyle(
                                    fontSize: 16), // Customize text style
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "or",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent dismissing by tapping outside
                      builder: (context) => const AlertDialog(
                        contentPadding: EdgeInsets.all(40),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 50, // Adjust width
                              height: 50, // Adjust height
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Please wait',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            Text(
                                "This will only take a moment..."), // Loading message
                          ],
                        ),
                      ),
                    );

                    userCreds = await signInWithGoogle();
                    print(userCreds);

                    Navigator.pop(context);

                    if (userCreds != null) {
                      loginNavigate();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Sorry, couldn\'t login using google...')),
                      );
                    }

                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: Text("Sorry sir"),
                    //       content: Text("Pending parin po yung Google Log in 🥺"),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context); // Close the dialog
                    //           },
                    //           child: Text("OK"),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Color(0xFFCFCFCF),
                        width: 1,
                      ),
                    ),
                    elevation: 1,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/google_logo.webp',
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Sign in with Google",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 170),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF8899AE)),
                    children: [
                      const TextSpan(text: "Don't have an account yet? "),
                      TextSpan(
                        text: "Create an account here",
                        style: const TextStyle(
                          color: Color(0xFF006644),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),

                // Row(
                //   children: [
                //     const Text('Don\'t have an account yet? '),
                //     TextButton(
                //         onPressed: () {
                //           Navigator.pushNamed(context, '/register');
                //         },
                //         child: const Text(
                //           'Sign up.',
                //           style: TextStyle(
                //               color: Colors.blue,
                //               fontWeight: FontWeight.bold),
                //         )),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

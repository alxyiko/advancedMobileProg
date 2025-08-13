import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class PostGoogleRegister extends StatefulWidget {
  const PostGoogleRegister({super.key});

  @override
  State<PostGoogleRegister> createState() => PostGoogleRegisterState();
}

class PostGoogleRegisterState extends State<PostGoogleRegister> {
  @override
  void initState() {
    // print(userData);
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _subdivController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _housenumController = TextEditingController();

  final List<String> items = [
    'Burol',
    'Burol I',
    'Burol II',
    'Burol III',
    'Datu Esmael',
    'Emmanuel Bergado I',
    'Emmanuel Bergado II',
    'Fatima I',
    'Fatima II',
    'Fatima III',
    'H-2',
    'Langkaan I',
    'Langkaan II',
    'Luzviminda I',
    'Luzviminda II',
    'Paliparan I',
    'Paliparan II',
    'Paliparan III',
    'Sabang',
    'Saint Peter I',
    'Saint Peter II',
    'Salawag',
    'Salitran I',
    'Salitran II',
    'Salitran III',
    'Salitran IV',
    'Sampaloc I',
    'Sampaloc II',
    'Sampaloc III',
    'Sampaloc IV',
    'Sampaloc V',
    'San Agustin I',
    'San Agustin II',
    'San Agustin III',
    'San Andres I',
    'San Andres II',
    'San Antonio de Padua I',
    'San Antonio de Padua II',
    'San Dionisio',
    'San Esteban',
    'San Francisco I',
    'San Francisco II',
    'San Isidro Labrador I',
    'San Isidro Labrador II',
    'San Jose',
    'San Juan',
    'San Lorenzo Ruiz I',
    'San Lorenzo Ruiz II',
    'San Luis I',
    'San Luis II',
    'San Manuel I',
    'San Manuel II',
    'San Mateo',
    'San Miguel',
    'San Miguel II',
    'San Nicolas I',
    'San Nicolas II',
    'San Roque',
    'San Simon',
    'Santa Cristina I',
    'Santa Cristina II',
    'Santa Cruz I',
    'Santa Cruz II',
    'Santa Fe',
    'Santa Lucia',
    'Santa Maria',
    'Santo Cristo',
    'Santo Niño I',
    'Santo Niño II',
    'Victoria Reyes',
    'Zone I',
    'Zone I-B',
    'Zone II',
    'Zone III',
    'Zone IV',
  ];

  String? gender;
  String? barangay;

  @override
  void dispose() {
    _firstnameController.dispose();
    _middlenameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit() async {
    String message = '';

    if (_formKey.currentState!.validate()) {
      bool nameExists = await checkName(
        _firstnameController.text.trim(),
        _middlenameController.text.trim(),
        _lastnameController.text.trim(),
      );

      if (nameExists) {
        message = 'This name already has an account!';
        return;
      }

      String messagea = await postGoogleSignup(
          firstname: _firstnameController.text,
          middlename: _middlenameController.text,
          lastname: _lastnameController.text,
          subdiv: _subdivController.text,
          street: _streetController.text,
          housenum: _housenumController.text,
          barangay: barangay as String,
          gender: gender as String);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messagea)),
      );
      Navigator.pop(context);
      // return;
    } else {
      message = 'Please try again!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Removes the background color
        elevation: 0,
        title: const Text(
          'Complete your profile~',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),

                const Text(
                  'Only one more step',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const Text(
                  'Complete your new account!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF676767),
                  ),
                ),

                const SizedBox(height: 50),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please enter your personal details here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF676767),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    labelText: "First name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your first name!"
                      : null,
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: _middlenameController,
                  decoration: const InputDecoration(
                    labelText: "Middle name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter a middle name!"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: "Last name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter last name!"
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                    controller: _phoneNumController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a phone number !";
                      } else if (value.length != 11) {
                        return "Please enter a valid phone number !";
                      }
                      return null;
                    }),
                const SizedBox(height: 12),

                Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sex',
                        style: TextStyle(
                          fontSize: 16, // Set font size to 16
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'MALE',
                            groupValue: gender,
                            onChanged: (value) =>
                                setState(() => gender = value),
                            activeColor:
                                Colors.green, // Makes selected radio green
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'FEMALE',
                            groupValue: gender,
                            onChanged: (value) =>
                                setState(() => gender = value),
                            activeColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 13),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please enter your address details here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF676767),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _housenumController,
                  decoration: const InputDecoration(
                    labelText: "House Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a House Number!";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: "Street Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Street name!";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _subdivController,
                  decoration: const InputDecoration(
                    labelText: "Subdivision",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Subdivision!";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: barangay,
                  hint: const Text('Select Barangay'),
                  isExpanded: true,
                  decoration: const InputDecoration(),
                  onChanged: (String? newValue) =>
                      setState(() => barangay = newValue),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity, // Takes full width
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006644), // Button background
                      foregroundColor: Colors.white, // Text color
                      textStyle:
                          const TextStyle(fontSize: 16), // Customize text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),

                const SizedBox(height: 25),

                // RichText(
                //   text: TextSpan(
                //     style: const TextStyle(
                //         fontSize: 16, color: Color(0xFF797B81)), // Default style
                //     children: [
                //       const TextSpan(
                //           text: 'Already have an account? '), // Normal text
                //       TextSpan(
                //         text: 'Login', // Clickable text
                //         style: const TextStyle(
                //           color: Color(0xFF006644),
                //           fontWeight: FontWeight.bold,
                //         ),
                //         recognizer: TapGestureRecognizer()
                //           ..onTap = () {
                //             Navigator.pushNamed(
                //                 context, '/login'); // Navigate to login
                //             // Navigator.popUntil(context, ModalRoute.withName('/login'))
                //           },
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 16),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text('Already have an account? '),
                //     TextButton(
                //       onPressed: () {
                //           // Navigator.popUntil(context, ModalRoute.withName('/login'));
                //         Navigator.pushNamed(context, '/login');
                //       },
                //       child: const Text(
                //         'Login',
                //         style: TextStyle(
                //             color: Colors.blue, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

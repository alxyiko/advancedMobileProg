import 'package:firebase_nexus/FirebaseOperations/firebaseLogin.dart';
import 'package:flutter/material.dart';

class StepOne extends StatefulWidget {
  const StepOne({super.key});

  @override
  State<StepOne> createState() => StepOneState();
}

class StepOneState extends State<StepOne> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

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
  String? barangay ;

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

      if (await checkUserExists(_emailController.text)) {
        message = 'This email already has an account!';
        return;
      }

        
        // message = await signUpUser(
        //   email: _emailController.text, 
        //   password: _passwordController.text, 
        //   firstname: _firstnameController.text, 
        //   middlename: _middlenameController.text, 
        //   lastname: _lastnameController.text, 
        //   barangay: barangay as String,   
        //   gender: gender as String) ;  


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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sign up!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
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
                    labelText: "Middlename",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter a middlename!"
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
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter last name!"
                      : null,
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    const Text('Sex:'),
                    RadioListTile<String>(
                      title: const Text('MALE'),
                      value: 'MALE',
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                    RadioListTile<String>(
                      title: const Text('FEMALE'),
                      value: 'FEMALE',
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: barangay,
                  hint: const Text('Select Barangay'),
                  isExpanded: true,
                  onChanged: (String? newValue) =>
                      setState(() => barangay = newValue),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
                TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Enter email",
                          border: OutlineInputBorder(),
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
                        height: 12,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Enter password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a password!";
                          } else if(value != _cpasswordController.text) {
                            return "passwords do not match!";
                          } else if (value.length < 8) {
                            return "passwords have to be at least 8 characters!";
                          }
                          
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _cpasswordController,
                        decoration: const InputDecoration(
                          labelText: "Enter password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the password again!";
                          } else if(value != _passwordController.text) {
                            return "passwords do not match!";
                          } else {
                            return null;
                          }
                        },
                      ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: () {
                          Navigator.popUntil(context, ModalRoute.withName('/login'));
                        // Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
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

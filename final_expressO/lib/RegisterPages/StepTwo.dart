import 'package:firebase_nexus/RegisterPages/PicStorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StepTwo extends StatefulWidget {
  const StepTwo({super.key});

  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepTwo> {
  final ImagePicker _picker = ImagePicker();
  static XFile? _RequirementImage;

    Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _RequirementImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RequirementImage == null
                ? const Text("No image selected")
                : Image.file(File(_RequirementImage!.path)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCamera,
              child: const Text("Open Camera"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: StepTwo()));

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvxplore/user/userui.dart';
import 'dart:developer' as devtools;


void main() {
  runApp(const Dataset());
}

class Dataset extends StatelessWidget {
  const Dataset({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Identification',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filePath;
  String label = '';

  String getAnimalInfo(String label) {
    if (label.contains('cat')) {
      return 'Animal: Cat\n'
          'Average Height: 9-10 inches\n'
          'Average Weight: 9-11 lbs\n'
          'Habits: Solitary hunters, playful and curious\n'
          'Region: Found worldwide as domestic pets\n'
          'Life Expectancy: 12-16 years\n'
          'Scientific Name: Felis catus';
    } else if (label.contains('dog')) {
      return 'Animal: Dog\n'
          'Average Height: 10-30 inches (depending on breed)\n'
          'Average Weight: 10-100 lbs (depending on breed)\n'
          'Habits: Loyal, social, and protective animals\n'
          'Region: Found worldwide as domestic pets\n'
          'Life Expectancy: 10-13 years\n'
          'Scientific Name: Canis lupus familiaris';
    } else if (label.contains('elephant')) {
      return 'Animal: Elephant\n'
          'Average Height: 8-13 feet\n'
          'Average Weight: 5,000-14,000 lbs\n'
          'Habits: Social animals, live in herds led by matriarchs\n'
          'Region: Found in Africa and Asia\n'
          'Life Expectancy: 60-70 years\n'
          'Scientific Name: Loxodonta africana (African) / Elephas maximus (Asian)';
    } else if (label.contains('lion')) {
      return 'Animal: Lion\n'
          'Average Height: 4-6 feet (at the shoulder)\n'
          'Average Weight: 300-500 lbs (male), 250-350 lbs (female)\n'
          'Habits: Social animals, live in prides\n'
          'Region: Found in Africa and parts of India (Asiatic lions)\n'
          'Life Expectancy: 10-14 years in the wild, up to 20 years in captivity\n'
          'Scientific Name: Panthera leo';
    } else {
      return 'Unknown animal. Please consult a zoologist for more information.';
    }
  }

  Future<void> _tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    var imageFile = File(image.path);

    setState(() {
      filePath = imageFile;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.4,
      asynch: true,
    );

    if (recognitions == null || recognitions.isEmpty) {
      devtools.log("Recognitions is Null or Empty");
      return;
    }

    devtools.log("Recognitions: ${recognitions.toString()}");

    setState(() {
      label = recognitions[0]['label'].toString().toLowerCase();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserInterface()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Animal Identification"),
          backgroundColor: Colors.green.shade700,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade700, width: 2),
                    image: filePath == null
                        ? const DecorationImage(
                      image: AssetImage('assets/upload.jpg'),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: FileImage(filePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (filePath == null) ...[
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Take a Photo"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Pick from Gallery"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                if (label.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Diagnosis: ${label[0].toUpperCase()}${label.substring(1)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.shade700, width: 2),
                        ),
                        child: Text(
                          'Precaution & Prevention:\n${getAnimalInfo(label)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vvxplore/user/userui.dart';
import 'dart:ui';
import 'cb.dart';

void main() {
  runApp(const Dataset());
}

class Dataset extends StatelessWidget {
  const Dataset({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? filePath;
  String label = '';

  String getAnimalInfo(String label) {
    if (label.contains('cat')) {
      return 'Animal: Cat\nHabits: Curious\nRegion: Worldwide\nLife: 12-16 yrs\nScientific: Felis catus';
    } else if (label.contains('dog')) {
      return 'Animal: Dog\nHabits: Loyal\nRegion: Worldwide\nLife: 10-13 yrs\nScientific: Canis lupus';
    } else if (label.contains('elephant')) {
      return 'Animal: Elephant\nHabits: Social\nRegion: Africa/Asia\nLife: 60-70 yrs\nScientific: Loxodonta';
    } else if (label.contains('lion')) {
      return 'Animal: Lion\nHabits: Prides\nRegion: Africa/India\nLife: 10-14 yrs\nScientific: Panthera leo';
    } else {
      return 'Unknown animal. Please consult a zoologist.';
    }
  }

  Future<void> _tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;
    File imageFile = File(image.path);

    setState(() => filePath = imageFile);

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.4,
      asynch: true,
    );

    setState(() {
      label = (recognitions?.isNotEmpty ?? false)
          ? recognitions![0]['label'].toString().toLowerCase()
          : 'Not detected';
    });
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserInterface()),
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Animal Identifier'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _glassCard(
                    child: Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: filePath != null
                            ? DecorationImage(
                          image: FileImage(filePath!),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage("assets/upload.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _actionButton(Icons.camera_alt, "Camera", () => pickImage(ImageSource.camera)),
                      const SizedBox(width: 16),
                      _actionButton(Icons.photo_library, "Gallery", () => pickImage(ImageSource.gallery)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (label.isNotEmpty) ...[
                    Text(
                      'Identified: ${label[0].toUpperCase()}${label.substring(1)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _glassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          getAnimalInfo(label),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white30, width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String text, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.green[700]),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

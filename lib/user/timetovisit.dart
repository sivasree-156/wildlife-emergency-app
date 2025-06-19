
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;
import 'package:url_launcher/url_launcher.dart';
import 'package:vvxplore/user/userui.dart';
import 'package:vvxplore/user/weather.dart';

void main() {
  runApp(const DeepLearning());
}

class DeepLearning extends StatelessWidget {
  const DeepLearning({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Place Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DeepLearningdsd(),
    );
  }
}

class DeepLearningdsd extends StatefulWidget {
  final String? name;
  final String? email;
  final String? mobile;
  final String? ukey;

  const DeepLearningdsd({
    Key? key,
    this.name,
    this.email,
    this.mobile,
    this.ukey,
  }) : super(key: key);

  @override
  State<DeepLearningdsd> createState() => _TouristHomePageState();
}

class _TouristHomePageState extends State<DeepLearningdsd> {
  File? filePath;
  String label = '';



  PlaceDescription getPlaceClass(String label) {
    if (label.contains("0 kanyakumari")) {
      return Kanyakumari();
    } else if (label.contains("1 kodaikanal")) {
      return Kodaikanal();
    } else if (label.contains("2 madurai")) {
      return Madurai();
    } else if (label.contains("3 mahabalipuram")) {
      return Mahabalipuram();
    } else if (label.contains("4 namakkal")) {
      return Namakkal();
    } else if (label.contains("5 ooty")) {
      return Ooty();
    } else if (label.contains("6 rameshwaram")) {
      return Rameshwaram();
    } else if (label.contains("7 red Fort")) {
      return RedFort();
    } else if (label.contains("8 thanjavur Periya Kovil")) {
      return ThanjavurPeriyaKovil();
    } else if (label.contains("9 tuticorin")) {
      return Tuticorin();
    } else if (label.contains("10 uvari")) {
      return Uvari();
    } else if (label.contains("11 valaparai")) {
      return Valaparai();
    } else {
      return DefaultPlace();
    }
  }




  Future<void> _tfLteInit() async {
    await Tflite.loadModel(
      model: "assets/ttv/model_unquant.tflite",
      labels: "assets/ttv/labels.txt",
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

    if (recognitions == null) {
      devtools.log("recognitions is Null");
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserInterface(

        ),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Xplore Place Recognition"),
          backgroundColor: Colors.deepOrange[700],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Upload an Image to Identify Wildlife Place Risks And References',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade700),
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
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Pick from Gallery"),
                  ),
                ],
                const SizedBox(height: 30),
                if (label.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'Place Identified: ${label[0].toUpperCase()}${label.substring(1)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      getPlaceClass(label).buildPlaceDetails(),
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

abstract class PlaceDescription {
  Widget buildPlaceDetails();
}


class Kodaikanal extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "10.2381",
            Longitude: "77.4892",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 10.2381, Longitude: 77.4892");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Kodaikanal", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Deforestation", "https://www.thehindu.com/news/national/tamil-nadu/kodaikanal-hills-losing-forest-cover/article30515726.ece", "  - Rapid urbanization and illegal construction have led to significant deforestation in Kodaikanal. The loss of forest cover has disrupted local ecosystems, reduced biodiversity, and increased soil erosion, threatening the stability of the hills."),
              _buildRiskTile("Water Pollution", "https://www.thenewsminute.com/article/pollution-kodaikanal-lake-water-has-high-levels-lead-and-mercury-study-139839", "  - Kodaikanal Lake and other water bodies face pollution from tourism activities, plastic waste, and historical industrial contamination. The presence of heavy metals from past industrial activities continues to affect water quality."),
              _buildRiskTile("Plastic Pollution", "https://www.dtnext.in/News/TamilNadu/2019/06/05020850/1046089/Kodaikanal-littered-with-plastic-waste-.vpf", "  - The hill station struggles with massive plastic waste accumulation due to tourism. Single-use plastics clog drains, pollute water bodies, and harm wildlife in the sensitive ecosystem."),
              _buildRiskTile("Unregulated Tourism", "https://www.thehindu.com/news/national/tamil-nadu/kodaikanal-bearing-the-brunt-of-tourism/article25976177.ece", "  - Overcrowding during peak seasons leads to environmental stress, with visitors often venturing into restricted areas, trampling vegetation, and leaving behind waste."),
              _buildRiskTile("Climate Change", "https://www.newindianexpress.com/states/tamil-nadu/2022/may/16/climate-change-affecting-kodaikanals-weather-pattern-2454527.html", "  - Changing weather patterns have affected Kodaikanal's famous misty climate. Erratic rainfall, rising temperatures, and reduced mist cover are altering the local microclimate."),
              _buildRiskTile("Illegal Construction", "https://timesofindia.indiatimes.com/city/madurai/kodaikanal-illegal-construction-threat-to-hill-station/articleshow/71539757.cms", "  - Unauthorized buildings and resorts have mushroomed across the hills, violating environmental norms and putting pressure on the fragile hill ecosystem."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Ecological Imbalance", Colors.orange),
              _descriptionText("- Climate change and human activities threaten Kodaikanal's delicate ecological balance."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 25%", Colors.purple, Icons.warning,
                  "- Moderate-risk percentage indicates growing environmental concerns that need immediate attention."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists & Pilgrims", Colors.green, Icons.people,
                  "- The destination attracts nature lovers, honeymooners, and pilgrims, creating seasonal pressure on infrastructure."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor environmental changes, basic pollution
10% - 20%                Moderate Risk              Deforestation visible in certain areas
20% - 30%                Water Risk                 Lake pollution affecting aquatic life
30% - 40%                Tourism Impact             Overcrowding during peak seasons
40% - 50%                Plastic Pollution          Accumulation in water bodies and forests
50% - 60%                Climate Change Effects     Changing weather patterns
60% - 70%                Landslide Risk             Due to deforestation and construction
70% - 80%                Biodiversity Loss          Endemic species threatened
80% - 90%                Water Shortage             Depleting water resources
90% - 100%               Ecological Collapse        Complete disruption of local ecosystem
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Poombarai Village", Colors.teal, Icons.place,
                  "- Traditional terraced farming village offering authentic Kodai experience away from crowds."),

            ],
          ),
        );
      },
    );
  }

  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}


class Madurai extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "9.9252",
            Longitude: "78.1198",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 9.9252, Longitude: 78.1198");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Madurai", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Air Pollution", "https://www.thehindu.com/news/cities/Madurai/madurai-third-most-polluted-city-in-state/article65925970.ece", "  - Madurai faces significant air pollution from vehicular emissions, industrial activities, and construction dust. The particulate matter levels often exceed safe limits, affecting both historical structures and public health."),
              _buildRiskTile("Water Scarcity", "https://www.thehindu.com/news/cities/Madurai/water-scarcity-hits-madurai-hard/article25631094.ece", "  - Frequent droughts and over-extraction of groundwater have led to water scarcity issues, impacting the Vaigai River and the city's ecosystem. This affects the microclimate around historical monuments."),
              _buildRiskTile("Urban Encroachment", "https://www.thehindu.com/news/cities/Madurai/encroachments-near-meenakshi-temple-to-be-removed/article32616658.ece", "  - Unplanned urban growth has led to encroachments near heritage sites, altering the traditional character of the city and putting pressure on ancient structures."),
              _buildRiskTile("Tourism Pressure", "https://www.thehindu.com/news/cities/Madurai/meenakshi-temple-sees-record-number-of-visitors/article38030272.ece", "  - The Meenakshi Amman Temple receives millions of visitors annually, leading to wear and tear of ancient structures, littering, and increased pollution in the temple vicinity."),
              _buildRiskTile("Temperature Rise", "https://www.downtoearth.org.in/news/climate-change/tamil-nadu-s-temperature-rising-faster-than-global-average-86424", "  - Madurai has experienced a faster-than-average temperature increase, with more frequent heat waves that can accelerate the weathering of historical stone structures."),
              _buildRiskTile("Heritage Neglect", "https://www.thehindu.com/news/cities/Madurai/heritage-buildings-in-madurai-in-ruins/article66877804.ece", "  - Many heritage buildings in Madurai are in poor condition due to lack of maintenance, improper restoration attempts, and insufficient conservation funding."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change", Colors.orange),
              _descriptionText("- Climate change may intensify existing challenges with more extreme weather events and temperature fluctuations."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 15%", Colors.purple, Icons.warning,
                  "- Moderate risk level indicates need for proactive conservation measures."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Pilgrims & Tourists", Colors.green, Icons.people,
                  "- Religious pilgrims and cultural tourists form the majority of visitors, creating seasonal pressure on infrastructure."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor environmental changes
10% - 20%                Moderate Risk              Temperature effects on structures
20% - 30%                Structural Risk            Humidity damage to ancient paintings
30% - 40%                Water Scarcity Impact      Groundwater depletion affecting foundations
40% - 50%                Tourism Impact             Crowding during festival seasons
50% - 60%                Pollution Damage           Accumulated soot on temple carvings
60% - 70%                Urban Heat Island Effect   Increased local temperatures
70% - 80%                Monsoon Damage             Heavy rains flooding heritage areas
80% - 90%                Seismic Risk               Earthquake vulnerability
90% - 100%               Extreme Risk               Combined climate and human impacts
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Thiruparankundram", Colors.teal, Icons.place,
                  "- Ancient rock-cut temple with beautiful architecture and less crowded than main city sites."),

            ],
          ),
        );
      },
    );
  }

  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
class Mahabalipuram extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "12.6168",
            Longitude: "80.1920",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 12.6168, Longitude: 80.1920");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Mahabalipuram", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Coastal Erosion", "https://www.thehindu.com/news/national/tamil-nadu/rising-sea-levels-pose-threat-to-mahabalipuram-monuments/article29209493.ece",
                  "  - The UNESCO World Heritage site faces significant threats from rising sea levels and coastal erosion. Several ancient structures have already been submerged, and the shoreline has retreated considerably over the past decades."),
              _buildRiskTile("Saltwater Intrusion", "https://www.downtoearth.org.in/news/climate-change/rising-sea-levels-threaten-mahabalipuram-s-temples-66920",
                  "  - Saltwater intrusion from the Bay of Bengal is causing deterioration of the stone carvings and structures. The saline air accelerates weathering of the granite monuments."),
              _buildRiskTile("Monsoon Damage", "https://www.newindianexpress.com/states/tamil-nadu/2019/dec/06/heavy-rains-leave-mahabalipuram-heritage-sites-in-ruins-2072195.html",
                  "  - Heavy monsoon rains and flooding have caused structural damage to the ancient rock-cut temples and sculptures. Water seepage weakens the foundations."),
              _buildRiskTile("Tourism Pressure", "https://www.thehindu.com/news/cities/chennai/tourism-pressure-taking-toll-on-mamallapuram-monuments/article25980072.ece",
                  "  - Increasing tourist numbers lead to physical wear of the delicate carvings. Touching, climbing, and improper behavior accelerate deterioration."),
              _buildRiskTile("Urban Encroachment", "https://timesofindia.indiatimes.com/city/chennai/encroachments-near-mahabalipuram-monuments-worry-asi/articleshow/71535296.cms",
                  "  - Illegal constructions and urban development near the heritage zone threaten the site's integrity and visual aesthetics."),
              _buildRiskTile("Climate Change", "https://www.thehindu.com/sci-tech/energy-and-environment/unesco-sites-under-climate-threat/article25704090.ece",
                  "  - Increasing frequency of cyclones and extreme weather events in the Bay of Bengal region poses new threats to these ancient structures."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Sea Level Rise", Colors.orange),
              _descriptionText("- Projections indicate that parts of Mahabalipuram could be underwater by 2100 if current trends continue."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 35%", Colors.purple, Icons.warning,
                  "- Elevated risk due to coastal location and climate change impacts."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists & Pilgrims", Colors.green, Icons.people,
                  "- Mix of international tourists, domestic visitors, and religious pilgrims."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor weathering from normal conditions
10% - 20%                Moderate Risk              Visible salt deposits on sculptures
20% - 30%                Structural Risk           Cracks from seismic activity
30% - 40%                Water Damage Risk        Sea spray and high tides affecting structures
40% - 50%                Tourism Impact           Physical wear from visitor numbers
50% - 60%                Coastal Erosion         Shoreline retreat threatening monuments
60% - 70%                Foundation Weakening     Waterlogged soil affecting stability
70% - 80%                Weather Damage          Cyclone and storm surge damage
80% - 90%                Submersion Risk        Permanent flooding of some structures
90% - 100%               Extreme Risk            Complete loss of coastal monuments
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Tiger Cave", Colors.teal, Icons.place,
                  "- 4km north of main site, features unique rock-cut architecture and fewer crowds."),

            ],
          ),
        );
      },
    );
  }

  // Reuse the same helper methods from TajMahal class
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class Namakkal extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "11.2216",
            Longitude: "78.1658",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 11.2216, Longitude: 78.1658");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Namakkal", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Poultry Industry Pollution", "https://www.thehindu.com/news/national/tamil-nadu/poultry-units-cause-pollution-in-namakkal/article65496240.ece", "  - Namakkal's large poultry industry has caused significant environmental pollution, with improper waste disposal contaminating water sources and creating foul odors in surrounding areas."),
              _buildRiskTile("Groundwater Depletion", "https://www.downtoearth.org.in/news/water/groundwater-levels-decline-in-60-tamil-nadu-districts-67981", "  - Excessive groundwater extraction for agricultural and industrial use has led to declining water tables in the region, threatening long-term water security."),
              _buildRiskTile("Transportation Pollution", "https://timesofindia.indiatimes.com/city/madurai/namakkal-district-leads-in-vehicle-population-in-tn/articleshow/78778631.cms", "  - Namakkal has one of the highest vehicle densities in Tamil Nadu, leading to significant air pollution from vehicle emissions."),
              _buildRiskTile("Stone Quarrying", "https://www.newindianexpress.com/states/tamil-nadu/2022/jan/03/stone-quarrying-in-namakkal-tiruchengode-to-be-banned-2405494.html", "  - Stone quarrying activities in the Kolli Hills and surrounding areas have caused environmental degradation and soil erosion."),
              _buildRiskTile("Agricultural Runoff", "https://www.thehindu.com/news/national/tamil-nadu/fertiliser-overuse-affecting-soil-health-in-namakkal/article32981644.ece", "  - Excessive use of chemical fertilizers in agriculture has led to soil degradation and water contamination through runoff."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change", Colors.orange),
              _descriptionText("- Climate change may exacerbate water scarcity issues and affect agricultural productivity in Namakkal."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 15%", Colors.purple, Icons.warning,
                  "- Moderate risk percentage indicates need for sustainable development planning."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Pilgrims & Tourists", Colors.green, Icons.people,
                  "- Namakkal attracts visitors to its temples and fort, but tourism is less intensive than at major heritage sites."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor environmental changes
10% - 20%                Moderate Risk              Water scarcity and pollution issues
20% - 30%                Agricultural Risk          Soil degradation from farming practices
30% - 40%                Industrial Pollution      Poultry industry waste management
40% - 50%                Transportation Impact     Vehicle emissions affecting air quality
50% - 60%                Water Crisis              Severe groundwater depletion
60% - 70%                Health Risks              Pollution-related health issues
70% - 80%                Economic Impact           Poultry industry downturn
80% - 90%                Extreme Weather          Drought or flood conditions
90% - 100%               Critical Risk            Multiple combined threats
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Kolli Hills", Colors.teal, Icons.place,
                  "- The Kolli Hills offer beautiful landscapes and are known for their medicinal plants and waterfalls."),

            ],
          ),
        );
      },
    );
  }

  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
class Ooty extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "11.4102",
            Longitude: "76.6950",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 11.4102, Longitude: 76.6950");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Ooty (Udhagamandalam)", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Deforestation", "https://www.thehindu.com/news/national/tamil-nadu/ooty-losing-its-green-cover/article25723656.ece", "  - Rapid urbanization and illegal tree felling have reduced Ooty's forest cover. The loss of native shola forests threatens biodiversity and affects the region's microclimate, potentially impacting the famous tea gardens and water resources."),
              _buildRiskTile("Tourism Pressure", "https://timesofindia.indiatimes.com/travel/destinations/ooty-is-suffering-from-overtourism/gs65234371.cms", "  - Overcrowding during peak seasons leads to traffic congestion, pollution, and strain on local infrastructure. Unregulated construction of hotels and resorts has altered the hill station's character and put pressure on limited resources."),
              _buildRiskTile("Water Scarcity", "https://www.newindianexpress.com/states/tamil-nadu/2020/jan/06/water-crisis-hits-ooty-as-summer-approaches-2087720.html", "  - Despite being in a high-rainfall region, Ooty faces water shortages due to drying streams, damaged catchment areas, and increased demand from tourism and local populations."),
              _buildRiskTile("Plastic Pollution", "https://www.thehindu.com/news/national/tamil-nadu/plastic-waste-chokes-ooty-lake/article30524936.ece", "  - Popular sites like Ooty Lake and botanical gardens suffer from plastic waste accumulation, harming aquatic life and spoiling the natural beauty of the region."),
              _buildRiskTile("Climate Change", "https://www.downtoearth.org.in/news/climate-change/climate-change-is-affecting-tea-gardens-in-darjeeling-ooty-64065", "  - Changing rainfall patterns and rising temperatures affect tea production and alter the region's traditional weather patterns, impacting both agriculture and tourism."),
              _buildRiskTile("Invasive Species", "https://www.thehindu.com/sci-tech/energy-and-environment/wattle-invasion-threat-to-shola-forests-in-nilgiris/article22324044.ece", "  - Invasive species like wattle trees have spread rapidly, threatening native shola grasslands and the unique biodiversity of the Nilgiri Biosphere Reserve."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Ecological Imbalance", Colors.orange),
              _descriptionText("- Climate change and human activities may lead to irreversible ecological changes in Ooty's fragile ecosystem."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 25%", Colors.purple, Icons.warning,
                  "- Moderate-risk percentage indicates growing environmental concerns that need attention."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists & Nature Lovers", Colors.green, Icons.people,
                  "- Ooty attracts families, honeymooners, and nature enthusiasts, especially during summer months."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor environmental changes, seasonal variations
10% - 20%                Moderate Risk              Increased tourism pressure on infrastructure
20% - 30%                Ecological Risk            Loss of native species, invasive plant spread
30% - 40%                Water Scarcity            Drying of natural water sources
40% - 50%                Deforestation            Loss of shola forests affecting biodiversity
50% - 60%                Climate Impact           Changes affecting tea plantations and agriculture
60% - 70%                Landslide Risk          Heavy rains causing soil erosion
70% - 80%                Urbanization Pressure  Unplanned construction altering landscape
80% - 90%                Extreme Weather        Unpredictable rainfall and temperature swings
90% - 100%               Ecosystem Collapse    Complete breakdown of fragile mountain ecology
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Avalanche Lake", Colors.teal, Icons.place,
                  "- A pristine lake surrounded by rare endemic flora, less crowded than Ooty's main attractions."),

            ],
          ),
        );
      },
    );
  }

  // Reuse the same helper methods from TajMahal class
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}




class Rameshwaram extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "9.2881",
            Longitude: "79.3129",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 9.2881, Longitude: 79.3129");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Rameshwaram", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Coastal Erosion", "https://www.thehindu.com/news/national/tamil-nadu/rameshwaram-facing-coastal-erosion/article65388205.ece", "  - Rameshwaram's coastline has been experiencing significant erosion due to rising sea levels and changing wave patterns. This threatens the island's infrastructure and sacred sites, including the famous Ramanathaswamy Temple."),
              _buildRiskTile("Cyclone Damage", "https://www.ndtv.com/tamil-nadu-news/cyclone-nivar-rameshwaram-temple-closed-after-heavy-rain-2329379", "  - The region is vulnerable to cyclones which have caused damage to historical structures. Cyclones bring strong winds and flooding that can weaken ancient temple structures."),
              _buildRiskTile("Saltwater Intrusion", "https://www.downtoearth.org.in/news/water/saltwater-intrusion-threatens-groundwater-in-rameshwaram-63008", "  - Increasing saltwater intrusion into freshwater aquifers affects both the local ecosystem and the availability of drinking water. This also accelerates corrosion of metal structures in temples."),
              _buildRiskTile("Tourism Pressure", "https://www.newindianexpress.com/states/tamil-nadu/2022/nov/28/rameshwaram-temple-sees-heavy-rush-of-devotees-2523203.html", "  - Heavy tourist footfall, especially during religious seasons, puts stress on the island's infrastructure and ancient temple structures. Unregulated tourism can lead to wear and tear of heritage sites."),
              _buildRiskTile("Coral Reef Degradation", "https://www.thehindu.com/sci-tech/energy-and-environment/gulf-of-mannar-lost-25-of-its-coral-reefs-in-last-10-years/article33424334.ece", "  - The coral reefs around Rameshwaram, part of the Gulf of Mannar Marine National Park, have been degrading due to climate change and human activities, affecting the marine ecosystem that protects the island."),
              _buildRiskTile("Religious Infrastructure Expansion", "https://www.thehindu.com/news/national/tamil-nadu/rameshwaram-temple-trust-plans-mega-development-projects/article33227732.ece", "  - Expansion projects around religious sites sometimes overlook environmental concerns, potentially affecting the delicate coastal ecosystem and putting additional pressure on limited land resources."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Sea Level Rise", Colors.orange),
              _descriptionText("- Rising sea levels due to climate change pose an existential threat to the low-lying island of Rameshwaram."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 25%", Colors.purple, Icons.warning,
                  "- Moderate-high risk percentage due to coastal vulnerabilities and climate change impacts."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Pilgrims & Tourists", Colors.green, Icons.people,
                  "- Rameshwaram attracts both religious pilgrims and tourists interested in its natural beauty and cultural heritage."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor coastal erosion, normal seasonal variations
10% - 20%                Moderate Risk              Increased salinity in groundwater, minor structural damage
20% - 30%                Coastal Risk               Significant beach erosion, threat to coastal infrastructure
30% - 40%                Flood Risk                 Increased flooding during high tides and storms
40% - 50%                Temple Damage Risk         Saltwater corrosion affecting temple structures
50% - 60%                Water Scarcity            Freshwater shortages due to saltwater intrusion
60% - 70%                Cyclone Vulnerability      Increased intensity and frequency of cyclones
70% - 80%                Habitat Loss              Marine ecosystem degradation affecting livelihoods
80% - 90%                Infrastructure Risk       Roads and buildings at risk from rising seas
90% - 100%               Existential Threat        Parts of island becoming uninhabitable
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Dhanushkodi", Colors.teal, Icons.place,
                  "- The ghost town of Dhanushkodi offers hauntingly beautiful ruins and beaches at India's southeastern tip."),

            ],
          ),
        );
      },
    );
  }

  // Reuse the same helper methods from TajMahal class
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
class Tuticorin extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "8.7642",
            Longitude: "78.1348",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 8.7642, Longitude: 78.1348");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Tuticorin (Thoothukudi)", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Industrial Pollution", "https://www.thehindu.com/news/national/tamil-nadu/thoothukudi-industries-cause-air-water-pollution/article30564034.ece", "  - Tuticorin's industrial area, particularly the Sterlite copper smelter plant, has been a major source of air and water pollution. Emissions of sulfur dioxide and other toxic gases have caused respiratory problems among residents and affected marine life in the Gulf of Mannar."),
              _buildRiskTile("Marine Pollution", "https://www.downtoearth.org.in/news/water/thoothukudi-port-expansion-threatens-gulf-of-mannar-s-marine-ecosystem-61655", "  - Expansion of Tuticorin port and increased shipping activities have led to marine pollution, threatening the fragile ecosystem of the Gulf of Mannar. Oil spills, ballast water discharge, and dredging activities have damaged coral reefs and affected fish populations."),
              _buildRiskTile("Water Scarcity", "https://www.newindianexpress.com/states/tamil-nadu/2019/may/21/thoothukudi-water-crisis-deepens-as-summer-peaks-1980850.html", "  - Despite being a coastal city, Tuticorin faces severe water scarcity due to over-extraction of groundwater, salinity intrusion, and inadequate rainfall. The situation worsens during summer months, affecting both residents and industries."),
              _buildRiskTile("Coastal Erosion", "https://www.researchgate.net/publication/328054044_Assessment_of_Shoreline_Changes_for_Thoothukudi_Coast_of_Tamil_Nadu_using_Remote_Sensing_and_Geospatial_Techniques", "  - Rising sea levels and changing wave patterns have caused significant coastal erosion in Tuticorin, threatening infrastructure and habitats. The erosion has been particularly severe along the Threspuram and Roche Park areas."),
              _buildRiskTile("Salt Pan Encroachment", "https://www.thehindu.com/news/national/tamil-nadu/encroachment-of-salt-pans-threat-to-thoothukudi-coast/article66514700.ece", "  - Illegal encroachment of salt pans for urban development has disrupted the natural coastal ecosystem and reduced the region's traditional salt production capacity."),
              _buildRiskTile("Thermal Plant Pollution", "https://www.thehindu.com/news/cities/Madurai/ntpc-plants-in-thoothukudi-continue-to-pollute/article33311516.ece", "  - Coal-fired thermal power plants in and around Tuticorin have been significant sources of air pollution, emitting fly ash and other particulate matter that affects air quality and public health."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change Impact", Colors.orange),
              _descriptionText("- Tuticorin faces increasing threats from climate change, including sea level rise, more intense cyclones, and coastal flooding."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 25%", Colors.purple, Icons.warning,
                  "- Moderate-high risk percentage due to industrial activity, climate vulnerability, and water stress."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Business/Tourists", Colors.green, Icons.people,
                  "- The city attracts business visitors due to its port and industries, and some tourists visiting nearby islands and religious sites."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor industrial pollution effects
10% - 20%                Moderate Risk              Air quality degradation affecting health
20% - 30%                Coastal Risk               Increased erosion and flooding
30% - 40%                Water Stress              Severe water scarcity issues
40% - 50%                Industrial Risk          Major industrial accidents potential
50% - 60%                Marine Ecosystem Risk    Damage to Gulf of Mannar ecosystem
60% - 70%                Climate Migration        Population displacement due to climate
70% - 80%                Infrastructure Risk      Port and coastal infrastructure damage
80% - 90%                Extreme Weather          Cyclones and storm surges
90% - 100%               Economic Collapse        Industrial and port activity disruption
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Hare Island", Colors.teal, Icons.place,
                  "- Hare Island, part of the Gulf of Mannar Marine National Park, offers pristine beaches and rich marine biodiversity."),

            ],
          ),
        );
      },
    );
  }

  // Reuse the same helper methods from TajMahal class
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class Uvari extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "8.1833",
            Longitude: "77.4167",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 8.1833, Longitude: 77.4167");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Uvari", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Coastal Erosion", "https://www.thehindu.com/news/national/tamil-nadu/uvari-coast-faces-severe-erosion/article65448568.ece", "  - Uvari's coastline has been experiencing severe erosion due to rising sea levels and changing wave patterns. This threatens local infrastructure, fishing communities, and the natural beauty of the area."),
              _buildRiskTile("Cyclone Damage", "https://timesofindia.indiatimes.com/city/chennai/cyclone-ockhi-leaves-trail-of-destruction-in-tamil-nadu-coastal-villages/articleshow/61885755.cms", "  - Cyclones like Ockhi have caused significant damage to Uvari's coastal areas, destroying homes, fishing boats, and disrupting the livelihoods of local communities."),
              _buildRiskTile("Saltwater Intrusion", "https://www.downtoearth.org.in/news/water/saltwater-intrusion-threatens-tamil-nadu-s-coastal-groundwater-74480", "  - Increasing saltwater intrusion into freshwater sources has affected agriculture and drinking water supplies in Uvari and surrounding regions."),
              _buildRiskTile("Fisheries Decline", "https://www.newindianexpress.com/states/tamil-nadu/2022/jan/10/overfishing-declining-catch-haunt-fishermen-in-kanyakumari-2407592.html", "  - Overfishing and changing ocean conditions have led to declining fish stocks, impacting the primary livelihood of Uvari's residents."),
              _buildRiskTile("Tourism Pressure", "https://www.thehindu.com/news/national/tamil-nadu/kanyakumari-district-tourism/article34022771.ece", "  - Growing tourism in the region, while economically beneficial, has put pressure on local resources and ecosystems in Uvari and nearby areas."),
              _buildRiskTile("Coral Reef Degradation", "https://www.frontiersin.org/articles/10.3389/fmars.2020.00226/full", "  - Nearby coral reef ecosystems have suffered from bleaching and degradation due to rising sea temperatures and human activities."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change", Colors.orange),
              _descriptionText("- Climate change poses an existential threat to Uvari's coastal ecosystem and communities."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 35%", Colors.purple, Icons.warning,
                  "- Moderate-high risk percentage indicates significant vulnerability to climate impacts."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Pilgrims & Tourists", Colors.green, Icons.people,
                  "- Uvari attracts religious pilgrims to its ancient church and beach tourists, creating seasonal pressures."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor coastal changes, seasonal variations
10% - 20%                Moderate Risk              Increased erosion, occasional storm damage
20% - 30%                Infrastructure Risk        Damage to coastal roads and buildings
30% - 40%                Livelihood Risk           Impact on fishing industry and local economy
40% - 50%                Water Security Risk       Freshwater scarcity due to saltwater intrusion
50% - 60%                Habitat Loss              Disappearance of coastal ecosystems
60% - 70%                Community Displacement    Forced migration due to land loss
70% - 80%                Extreme Weather          Frequent severe cyclones and storms
80% - 90%                Cultural Heritage Risk   Threat to historical sites and traditions
90% - 100%               Existential Risk         Potential complete inundation of coastal areas
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Kanyakumari", Colors.teal, Icons.place,
                  "- Just south of Uvari, Kanyakumari offers stunning sunrise/sunset views and cultural significance."),

            ],
          ),
        );
      },
    );
  }

  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
class Kanyakumari extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "8.0883",
            Longitude: "77.5385",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 8.0883, Longitude: 77.5385");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Kanyakumari", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Coastal Erosion", "https://www.thehindu.com/news/national/tamil-nadu/coastal-erosion-kanyakumari/article29408350.ece", "  - Coastal erosion in Kanyakumari has been exacerbated by rising sea levels and human intervention, leading to the loss of land and natural beauty along the shoreline."),
              _buildRiskTile("Plastic Pollution", "https://timesofindia.indiatimes.com/city/madurai/plastic-waste-kanyakumari-tourists/articleshow/68907824.cms", "  - Tourist activities have contributed to plastic pollution along the beaches, affecting marine life and spoiling the natural beauty of the area."),
              _buildRiskTile("Deforestation", "https://www.newindianexpress.com/states/tamil-nadu/2021/mar/18/kanyakumari-deforestation-impact", "  - Deforestation in surrounding hills has led to soil erosion and habitat loss, affecting biodiversity and natural water resources."),
              _buildRiskTile("Climate Change", "https://www.downtoearth.org.in/news/climate-change-impact-on-kanyakumari-74159", "  - Climate change has impacted rainfall patterns and sea levels, further exacerbating environmental issues in the region."),


              const SizedBox(height: 30),

              _animatedText("Future Issues: Sea Level Rise", Colors.orange),
              _descriptionText("-  Sea level rise due to global warming poses a significant threat to Kanyakumari's coastal ecosystem and low-lying areas."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 60%", Colors.purple, Icons.warning,
                  "-  Studies indicate that Kanyakumari faces a 60% risk of being affected by coastal flooding and erosion in the next few decades."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists and Pilgrims", Colors.green, Icons.people,
                  "-  Kanyakumari attracts a mix of tourists and pilgrims due to its religious significance and natural beauty."),
              const SizedBox(height: 20),



              _animatedText("Impact on Agriculture and Biodiversity", Colors.red),
              _descriptionText("-  Rising temperatures and changing rainfall patterns have impacted the region's agricultural productivity and biodiversity."),
              const SizedBox(height: 10),





              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minimal coastal pollution and safe marine life
10% - 20%                Moderate Risk              Small plastic waste affecting beach cleanliness
20% - 30%                Coral Reef Loss           Gradual coral reef damage due to water pollution
30% - 40%                Water Pollution Risk      Untreated sewage and plastic waste entering the sea
40% - 50%                Marine Life Decline       Decrease in fish and sea turtle population
50% - 60%                Tourism Impact            Over-tourism affecting natural resources and beach ecosystems
60% - 70%                Coastal Erosion           Sea level rise causing shoreline loss
70% - 80%                Water Contamination       Oil spills and chemical waste from boats
80% - 90%                Biodiversity Threat       Loss of native species like seabirds and marine plants
90% - 100%               Extreme Risk             Complete ecosystem imbalance due to combined pollution, erosion, and biodiversity loss
  """,
                  Colors.blue,
                  Icons.waves,
                  "Kanyakumari Coastal Risk"
              ),


              _animatedCard("Nearby Underrated Places: Vattakottai Fort", Colors.blue, Icons.place,
                  "-  Vattakottai Fort, located near Kanyakumari, offers scenic views of the coastline and serves as a historical site with minimal tourist crowds."),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}


class RedFort extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "28.6562",
            Longitude: "77.2410",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 28.6562, Longitude: 77.2410");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("RedFort", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Air Pollution", "https://www.thehindu.com/news/cities/Delhi/red-fort-air-pollution-threats/article26372019.ece", "  - The high levels of air pollution in Delhi have caused significant discoloration and deterioration of the red sandstone walls of the Red Fort. The accumulation of pollutants like sulfur dioxide weakens the structure over time."),
              _buildRiskTile("Encroachment", "https://www.timesofindia.indiatimes.com/city/delhi/red-fort-encroachment-issues/articleshow/68382510.cms", "  - Illegal encroachment around the Red Fort has posed a threat to its heritage value. Unauthorized construction and commercialization in the vicinity have affected the monument's historical ambiance."),
              _buildRiskTile("Vandalism", "https://www.ndtv.com/delhi-news/red-fort-vandalism-incident-news", "  - Instances of vandalism by tourists and protesters have damaged parts of the fort, including defacement of walls and theft of artifacts."),
              _buildRiskTile("Neglect", "https://www.thehindu.com/news/cities/Delhi/red-fort-neglect-maintenance-issues/article32884541.ece", "  - Lack of proper maintenance and delayed restoration work have led to the gradual deterioration of the Red Fort's structure and appearance."),


              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change", Colors.orange),
              _descriptionText("- Climate change may lead to increased rainfall, flooding, and temperature fluctuations, which could further weaken the Red Fort's sandstone structure and foundations."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 65%", Colors.purple, Icons.warning,
                  "- Based on environmental studies and urbanization patterns, the probability of the Red Fort facing significant environmental degradation in the next few decades is estimated at 65%."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists and Locals", Colors.green, Icons.people,
                  "- The Red Fort attracts both tourists and local residents, especially during national celebrations like Independence Day. This heavy footfall puts additional strain on the structure."),
              const SizedBox(height: 20),






              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor pollution from tourist activities
10% - 20%                Moderate Risk              Noise pollution from surrounding traffic
20% - 30%                Air Pollution             Dust and vehicle emissions affecting monument walls
30% - 40%                Structural Risk           Small cracks and discoloration due to pollution
40% - 50%                Tourist Overcrowding      Excessive footfall causing wear and tear
50% - 60%                Waste Management          Improper disposal of plastic and other waste
60% - 70%                Weathering Risk           Rain and wind eroding stone surfaces
70% - 80%                Restoration Need          Urgent restoration required for damaged areas
80% - 90%                Heritage Loss             Significant loss of original architecture and inscriptions
90% - 100%               Extreme Risk              Irreversible damage and potential closure for restoration
    """,
                  Colors.red,
                  Icons.castle,
                  "Red Fort"
              ),

              _animatedCard("Nearby Underrated Places: Chandni Chowk", Colors.blue, Icons.location_on,
                  "- Chandni Chowk, a historic market near the Red Fort, offers vibrant local culture and food experiences. Visiting this area provides a deeper insight into Old Delhi's heritage."),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}


class ThanjavurPeriyaKovil extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "10.7822",
            Longitude: "79.1315",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 10.7822, Longitude: 79.1315");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("TanjavurPeriyarKovil", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Weathering", "https://www.thehindu.com/news/national/tamil-nadu/brihadeeswarar-temple-weathering-issues/article3600458.ece", "  - The temple's granite stones are subject to weathering due to continuous exposure to sun, wind, and rain, leading to erosion of its intricate carvings and sculptures."),
              _buildRiskTile("Pollution", "https://www.timesofindia.indiatimes.com/city/trichy/air-pollution-threatens-temples/articleshow/67123450.cms", "  - Air pollution from nearby industrial regions contributes to the discoloration of the temple's stone surfaces, accelerating its degradation."),
              _buildRiskTile("Tourism", "https://www.newindianexpress.com/states/tamil-nadu/2021/jan/27/over-tourism-at-thanjavur-temple-damage", "  - Over-tourism at the temple site results in physical damage to the temple structure, especially on flooring and pathways, due to excessive foot traffic."),


              const SizedBox(height: 30),
              _animatedText("Future Issues: Climate Change", Colors.orange),
              _descriptionText("- Rising temperatures and unpredictable rainfall patterns could accelerate the weathering of the granite structure, causing more extensive damage in the coming decades."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 65%", Colors.purple, Icons.warning,
                  "- Based on environmental studies, the probability of significant damage to the temple due to environmental risks in the next few decades is estimated at 65%."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Tourists and Devotees", Colors.green, Icons.people,
                  "- The temple attracts both local devotees and international tourists, creating a mixed influx of visitors that adds to the pressure on its infrastructure."),
              const SizedBox(height: 20),



              _animatedCard("Heavy Foot Traffic", Colors.red, Icons.directions_walk,
                  "- Heavy foot traffic from thousands of tourists contributes to physical wear and tear of the temple's floors and delicate carvings."),



              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minimal structural damage due to natural weathering
10% - 20%                Moderate Risk              Air pollution causing slight discoloration of temple walls
20% - 30%                Ground Vibration Risk      Vibrations from nearby traffic affecting temple foundation
30% - 40%                Water Seepage Risk        Rainwater seepage weakening stone carvings
40% - 50%                Visitor Impact            Over-tourism leading to erosion of stone floors
50% - 60%                Pollution Impact          Industrial pollution affecting stone surface
60% - 70%                Structural Crack Risk     Cracks on temple walls due to aging and vibrations
70% - 80%                Climate Change Risk       Rising temperatures affecting stone durability
80% - 90%                Soil Erosion             Soil erosion around temple premises affecting stability
90% - 100%               Extreme Risk             Major structural damage due to combined natural and human factors
    """,
                  Colors.brown,
                  Icons.temple_hindu,
                  ""
              ),


              _animatedCard("Nearby Underrated Places: Saraswathi Mahal Library", Colors.blue, Icons.library_books,
                  "- The Saraswathi Mahal Library, one of the oldest libraries in Asia, contains rare manuscripts and offers a peaceful exploration of Tamil literature and history."),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class Valaparai extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    void navigateToWeather(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(
            Latitude: "10.3266",
            Longitude: "76.9513",
          ),
        ),
      );
    }

    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Latitude: 10.3266, Longitude: 76.9513");
                    navigateToWeather(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    elevation: 10,
                  ),
                  child: const Text("Show Live Weather", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.9),
                  child: const Text("Valparai", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 2)),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Past Risks:", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildRiskTile("Deforestation", "https://www.thehindu.com/news/national/tamil-nadu/deforestation-in-valparai-hill-station/article65438232.ece", "  - Large-scale deforestation for tea plantations and development projects has threatened the biodiversity of Valparai. The loss of forest cover has impacted wildlife corridors and increased human-animal conflicts."),
              _buildRiskTile("Human-Wildlife Conflict", "https://www.newindianexpress.com/states/tamil-nadu/2022/dec/05/elephant-deaths-in-valparai-raise-concerns-2526200.html", "  - Expansion of human settlements into forest areas has led to increased elephant-human conflicts. Several elephant deaths have been reported due to accidents and electrocution."),
              _buildRiskTile("Landslides", "https://www.dtnext.in/News/TamilNadu/2022/10/12062650/1383241/Valparai-landslips-cause-panic-among-residents.vpf", "  - Heavy rainfall and deforestation have caused frequent landslides in the region, damaging roads and properties while posing risks to local communities."),
              _buildRiskTile("Water Pollution", "https://www.thehindu.com/news/national/tamil-nadu/water-sources-in-valparai-plateau-contaminated/article33416837.ece", "  - Pesticide runoff from tea estates and improper waste disposal have contaminated water sources, affecting both wildlife and local communities."),
              _buildRiskTile("Climate Change", "https://www.downtoearth.org.in/news/climate-change/climate-change-is-affecting-tea-production-in-valparai-81075", "  - Changing rainfall patterns and rising temperatures have affected tea production and altered the region's microclimate."),
              _buildRiskTile("Tourism Pressure", "https://www.thehindu.com/news/national/tamil-nadu/unregulated-tourism-threatens-valparais-ecology/article65949406.ece", "  - Increasing tourist numbers without proper infrastructure has led to littering, noise pollution, and disturbance to wildlife habitats."),
              const SizedBox(height: 30),
              _animatedText("Future Issues: Biodiversity Loss", Colors.orange),
              _descriptionText("- Climate change and habitat fragmentation pose serious threats to Valparai's unique biodiversity."),
              const SizedBox(height: 10),

              _animatedCard("Risk Predictions: 25%", Colors.purple, Icons.warning,
                  "- Moderate-risk percentage indicates growing environmental concerns that need attention."),
              const SizedBox(height: 20),

              _animatedCard("Type of Visitors: Nature Enthusiasts", Colors.green, Icons.people,
                  "- Ecotourists, researchers, and tea plantation visitors form the majority of visitors."),
              const SizedBox(height: 20),

              _animatedCard(
                  """
Risk Percentage Range     Risk Type                   Description
1% - 10%                 Low Risk                   Minor environmental changes
10% - 20%                Moderate Risk              Deforestation impacts
20% - 30%                Biodiversity Risk          Habitat loss for endangered species
30% - 40%                Water Scarcity Risk        Changing rainfall patterns
40% - 50%                Human-Wildlife Conflict    Increasing elephant encounters
50% - 60%                Landslide Risk             Heavy rainfall impacts
60% - 70%                Agricultural Impact        Tea plantation expansion
70% - 80%                Climate Change Effects     Temperature rise affecting ecosystems
80% - 90%                Extreme Weather            Unpredictable monsoon patterns
90% - 100%               Ecological Collapse        Complete biodiversity loss
          """,
                  Colors.red,
                  Icons.warning,""
              ),
              const SizedBox(height: 20),

              _animatedCard("Nearby Underrated Places: Chinnakallar Falls", Colors.teal, Icons.place,
                  "- One of the highest waterfalls in the region, surrounded by lush greenery and less crowded than other tourist spots."),

            ],
          ),
        );
      },
    );
  }

  Widget _animatedText(String text, Color color) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _animatedCard(String title, Color color, IconData icon, String description) {
    return Card(
      elevation: 8,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRiskTile(String title, String url, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Spacer(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(url)),
                  child: const Text("Reference", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(description, style: const TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
class DefaultPlace extends PlaceDescription {
  @override
  Widget buildPlaceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Welcome to the Default Place", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("No data is available for this place at the moment."),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print("No coordinates available");
          },
          child: const Text("Show Coordinates"),
        ),
        const SizedBox(height: 20),
        const Text("Past Risks: Not Available", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
        const Text("Future Issues: Not Available"),
        const Text("Risk Predictions: Not Available"),
        const Text("Type of Visitors: Not Available"),
        const Text("Nearby Underrated Places: Not Available"),
      ],
    );
  }
}

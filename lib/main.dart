import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'env/env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
import 'package:custom_info_window/custom_info_window.dart';

Future<void> main() async {
  OpenAI.apiKey = Env
      .apiKey; // Initializes the package with that API key, all methods now are ready for use.

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    // create: (context) => MyAppState(),
    return MaterialApp(
      title: 'Ontario Wildfire',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 126, 126, 126)),
      ),
      home: MyHomePage(),
    );
    // );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    OntarioWildfireDashboard(),
    GeneratorPage(),
    FireMap(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Text('Wildfyre'),
          ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fireplace_rounded),
            label: 'Fire Prediction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wildfire Prediction System'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView for scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: AIimage()), // Display the AI-generated image here
            SizedBox(height: 20),
            AIRepsonse(), // Display the AI response widget here
          ],
        ),
      ),
    );
  }
}

class AIimage extends StatefulWidget {
  const AIimage({super.key});

  @override
  State<AIimage> createState() => _AIimageState();
}

class _AIimageState extends State<AIimage> {
  String? imageUrl; // This variable will hold the URL of the generated image
  bool isLoading =
      false; // A flag to show a loading spinner while generating image
  String? errorMessage; // To capture any errors during image generation

  @override
  void initState() {
    super.initState();
  }

  Future<void> getImage() async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Clear any previous errors
    });

    try {
      // Assuming you're using OpenAI to generate the image
      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt:
            "hyperreal forest fire perimeter in Chapleau Ontario in August with flame",
        n: 1,
        size: OpenAIImageSize.size256,
        responseFormat: OpenAIImageResponseFormat.url,
      );

      // Debug the response to ensure it's correct
      print('API response: ${image.data}');

      setState(() {
        // Retrieve the first generated image URL
        if (image.data.isNotEmpty && image.data[0].url != null) {
          imageUrl = image.data[0].url; // Extract the valid image URL
        } else {
          errorMessage = 'Failed to get a valid image URL';
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating image: $e';
        isLoading = false;
      });
      print('Error: $e'); // Print the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const CircularProgressIndicator(), // Show loading indicator while generating
        if (errorMessage != null)
          Text(errorMessage!), // Display error message if there's an error
        if (imageUrl != null)
          Image.network(imageUrl!), // Display the image if URL is valid
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: getImage, // Call the getImage function when pressed
          child: const Text('What would a fire look like today?'),
        ),
      ],
    );
  }
}

class AIRepsonse extends StatefulWidget {
  const AIRepsonse({super.key});

  @override
  State<AIRepsonse> createState() => _AIRepsonseState();
}

class _AIRepsonseState extends State<AIRepsonse> {
  String out = "";
  bool isLoading = false; // Tracks loading state

  @override
  void initState() {
    super.initState();
  }

  Future getOut() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Give a small paragraph predicting the fire spread rate in Chapleau Ontario. The FFMC is 89, the DMC is 19, the DC is 374, the ISI is 4.8, and the BUI is 33. Don't mention the provided values. Write the prediction in metres per minute. Only include spread rate and a small explanation in the answer.",
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "How fast would a fire spread in Chapleau Ontario today?",
        ),
      ],
      role: OpenAIChatMessageRole.user,
      name: "anas",
    );

    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      //responseFormat: {"type": 'json_object'},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    setState(() {
      out = chatCompletion.choices[0].message.content.toString();
      isLoading = false; // Hide loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.all(16.0), // Adds padding to the entire widget
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Button to trigger the API call
          ElevatedButton.icon(
            onPressed: getOut, // Call getOut on button press
            icon: const Icon(Icons.chat),
            label: const Text('Generate Prediction'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),

          const SizedBox(
              height: 20), // Adds spacing between the button and response

          // Show loading indicator while waiting for API response
          if (isLoading)
            const CircularProgressIndicator()
          else
            // Show the response or error message in a styled container
            out.isNotEmpty
                ? Card(
                    elevation: 4, // Add elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        out, // Display the API response
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const Text(
                    'Press the button to generate a prediction',
                    style: TextStyle(fontSize: 18),
                  )
        ]));
  }
}

class OntarioWildfireDashboard extends StatefulWidget {
  @override
  OntarioWildfireDashboardState createState() =>
      OntarioWildfireDashboardState();
}

class OntarioWildfireDashboardState extends State<OntarioWildfireDashboard> {
  String selectedTab = 'Current Situation';
  String selectedRegion = 'NorthEast'; // Default to NorthEast image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use a gradient background for the AppBar
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fireplace, // Icon to match the wildfire theme
              color: Colors.white,
              size: 24, // Reduced icon size
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Ontario Wildfire Dashboard',
                style: TextStyle(
                  fontSize: 20, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black.withOpacity(0.6),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis, // Handle text overflow
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Transparent background to show gradient
        elevation: 0, // Remove shadow/elevation to focus on the gradient
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Current Situation';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Current Situation'
                          ? Colors.red
                          : const Color.fromARGB(255, 252, 181, 181),
                    ),
                    child: Text(
                      'Current Situation',
                      style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Totals This Year';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Totals This Year'
                          ? Colors.red
                          : Color.fromARGB(255, 252, 181, 181),
                    ),
                    child: Text(
                      'Totals This Year',
                      style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16), // Adds spacing between tabs and content

            if (selectedTab == 'Current Situation') ...[
              // Current Situation Section
              CurrentSituation(),

              SizedBox(height: 16),

              // Fire Weather Map Section
              Text(
                'Fire Weather Map for Today',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRegion =
                            'NorthEast'; // Change to NorthEast image
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRegion == 'NorthEast'
                          ? Colors.blue
                          : const Color.fromARGB(255, 180, 221, 255),
                    ),
                    child: Text(
                      'NorthEast',
                      style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRegion =
                            'NorthWest'; // Change to NorthWest image
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRegion == 'NorthWest'
                          ? Colors.blue
                          : const Color.fromARGB(255, 180, 221, 255),
                    ),
                    child: Text(
                      'NorthWest',
                      style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Display the correct image based on the selected button
              Image.asset(
                selectedRegion == 'NorthEast'
                    ? 'assets/images/northeast.jpg'
                    : 'assets/images/northwest.jpg',
                height: 450,
                width: double.infinity,
                fit: BoxFit.fitHeight,
              ),

              SizedBox(height: 16),

              // Stages of Control Section
              StagesOfControl(),

              SizedBox(height: 16),

              // Contact Information Section
              ContactInformation(),
            ] else if (selectedTab == 'Totals This Year') ...[
              TotalsThisYear(),
            ],
          ],
        ),
      ),
    );
  }
}

class CurrentSituation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Provincial Situation Report:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Wrapping this section in a SingleChildScrollView to make it scrollable
              Container(
                height: 200, // Set the height for the scrollable section
                child: SingleChildScrollView(
                  child: Text(
                    'Northeast Region:\n'
                    '• No new wildland fires confirmed on September 14.\n'
                    '• 9 active fires: 1 under control, 8 being observed.\n'
                    '• Moderate to high fire hazard across the region.\n'
                    '• Fort Frances 13 (0.1 ha) is being observed.\n\n'
                    'Northwest Region:\n'
                    '• 4 new wildland fires confirmed on September 14:\n'
                    '   - Red Lake 45 (0.1 ha) under control.\n'
                    '   - Red Lake 46 (0.5 ha) being observed.\n'
                    '   - Sioux Lookout 39 (1.8 ha) not under control.\n'
                    '   - Fort Frances 14 (0.2 ha) not under control.\n'
                    '• 28 active fires: 2 not under control, 1 being held, 1 under control, 24 observed.\n'
                    '• Moderate to high fire hazard with extreme pockets near Red Lake and Sioux Lookout.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // The Report a Fire section
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report a Fire:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: '• To report a forest fire, call ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '310-FIRE (3473)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        text:
                            '• South of the French and Mattawa rivers, please call ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '911',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SummaryWidgets(),
      ],
    );
  }
}

class TotalsThisYear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(16.0), // Add padding around the entire widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Totals for the year refers to wildfire activity between April 1, 2024, and today\'s date.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: StatsBox(
                    icon: Icons.local_fire_department,
                    title: 'Wildfires Started',
                    number: 50,
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between boxes
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: StatsBox(
                    icon: Icons.nature_people,
                    title: 'Hectares Burned',
                    number: 1200,
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between boxes
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: StatsBox(
                    icon: Icons.check_circle_outline,
                    title: 'Extinguished Wildfires',
                    number: 45,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0), // Add padding to the left of the heading
            child: Text(
              'Wildfire Causes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CauseBox(
                    title: 'Lightning',
                    percentage: 50,
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between boxes
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CauseBox(
                    title: 'Human',
                    percentage: 30,
                  ),
                ),
              ),
              SizedBox(width: 16), // Space between boxes
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CauseBox(
                    title: 'Undetermined',
                    percentage: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryCard(
          icon: Icons.local_fire_department,
          title: 'Active Wildfires',
          number: 5,
          color: const Color.fromARGB(255, 224, 150, 0),
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.access_time,
          title: 'Started in Last 24 Hours',
          number: 2,
          color: Colors.red,
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.check_circle_outline,
          title: 'Declared Out in Last 24 Hours',
          number: 3,
          color: Colors.green,
        ),
        SizedBox(height: 10),
        SummaryCard(
          icon: Icons.calendar_today,
          title: 'Declared Out in Last 7 Days',
          number: 4,
          color: Colors.blue,
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int number;
  final Color color;

  SummaryCard({
    required this.icon,
    required this.title,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          number.toString(),
          style: TextStyle(
              fontSize: 24, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class StatsBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final int number;

  StatsBox({
    required this.icon,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CauseBox extends StatelessWidget {
  final String title;
  final int percentage;

  CauseBox({
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '(${percentage}%)',
            style: TextStyle(
                fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class StagesOfControl extends StatelessWidget {
  final List<Map<String, dynamic>> stages = [
    {'title': 'Out of Control', 'count': 2, 'total': 5, 'color': Colors.red},
    {'title': 'Being Held', 'count': 1, 'total': 5, 'color': Colors.orange},
    {'title': 'Under Control', 'count': 1, 'total': 5, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stages of Control',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...stages.map((stage) {
            final percentage = (stage['count'] / stage['total']) * 100;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  CircularPercentageIndicator(
                    percentage: percentage,
                    color: stage['color'],
                  ),
                  SizedBox(width: 16),
                  Text(
                    stage['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;
  final Color color;

  CircularPercentageIndicator({
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 6,
            backgroundColor: Colors.grey[200]!,
            color: color,
          ),
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ContactInformation extends StatelessWidget {
  // Method to launch phone dialer
  void _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information Title
          Text(
            'Contact Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Northeast Region
          Text(
            'Northeast Region',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('Alison Lake\nFire Information Officer'),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _launchPhoneDialer('705-564-6165');
            },
            child: Row(
              children: [
                Icon(Icons.phone, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  '705-564-6165',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),

          SizedBox(height: 16), // Spacing between sections

          // Northwest Region
          Text(
            'Northwest Region',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text('Alison Bezubiak\nFire Information Officer'),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _launchPhoneDialer('807-937-7330');
            },
            child: Row(
              children: [
                Icon(Icons.phone, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  '807-937-7330',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FireMap extends StatefulWidget {
  const FireMap({super.key});

  @override
  State<FireMap> createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  // late GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);
  final LatLng _center = const LatLng(50.000000, -85.000000);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }
  static List<LatLng> _getOntarioBoundary() {
    return [
      const LatLng(56.812444, -89.066491),
      const LatLng(52.895138, -95.262780),
      // const LatLng(57.597881, -96.053796), // Northern Ontario const boundary sample coordinates
      const LatLng(49.252913, -96.053796),
      const LatLng(41.721499, -83.002038),
      const LatLng(45.382425, -74.344811),
      const LatLng(47.915775, -79.486413),
      const LatLng(55.014941, -82.474694),
    ];
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final fireLocations = await locations.getFireLocations();

    final BitmapDescriptor high = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)),
      'assets/red_fire.png',
    );
    final BitmapDescriptor medium = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)),
      'assets/yellow_fire.png',
    );
    final BitmapDescriptor low = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(10, 10),
      ),
      'assets/green_fire.png',
    );
    //final CustomInfoWindowController _customInfoWindowController =
    CustomInfoWindowController();

    setState(() {
      _markers.clear();

      for (final place in fireLocations.places) {
        final severity = place.severity;
        BitmapDescriptor markerIcon;

        // Set the marker icon based on severity level
        if (severity == 'high') {
          markerIcon = high;
        } else if (severity == 'medium') {
          markerIcon = medium;
        } else {
          markerIcon = low;
        }
        final marker = Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet:
                "${place.address} now has a total of ${place.size} burnt hectares",
          ),
          icon: markerIcon,
        );

        _markers[place.name] = marker;
      }
    });
  }

  final Set<Polygon> ontBound = {
    Polygon(
      polygonId: const PolygonId('ontario_boundary'),
      strokeColor: Colors.black,
      // points: ont_bound.getOntarioBoundary(),
      points: _getOntarioBoundary(),
      strokeWidth: 3,
      fillColor: Colors.black.withOpacity(0.0), // Fill color with transparency
    ),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Fires'),
        elevation: 2,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          // target: LatLng(0, 0),
          zoom: 4.5,
        ),
        polygons: ontBound,
        markers: _markers.values.toSet(),
      ),
    );
    // );
  }
}

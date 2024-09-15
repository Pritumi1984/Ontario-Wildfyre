import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ontario Wildfire',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: OntarioWildfireDashboard(),
    );
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
        title: Text('Ontario Wildfire Dashboard'),
        centerTitle: true,
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
                        selectedRegion = 'NorthEast'; // Change to NorthEast image
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
                        selectedRegion = 'NorthWest'; // Change to NorthWest image
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: '• To report a forest fire, call ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '310-FIRE (3473)',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                        text: '• South of the French and Mattawa rivers, please call ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '911',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
      padding: const EdgeInsets.all(16.0), // Add padding around the entire widget
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
            padding: const EdgeInsets.only(left: 8.0), // Add padding to the left of the heading
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
          style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
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



